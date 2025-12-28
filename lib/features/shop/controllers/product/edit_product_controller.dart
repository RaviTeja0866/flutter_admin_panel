import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/product/product_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/similar_product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/specifications_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/brand_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_category_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';


import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/banner_model.dart';
import '../../models/product_specification_model.dart';
import '../../models/size_guide_model.dart';
import '../banner/banner_controller.dart';
import '../coupon/coupon_controller.dart';
import '../tag/create_and_update_tag_controller.dart';

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();

  // Obx for loading state and Product details
  final isLoading = false.obs;
  final isFeatured = false.obs;
  final selectedCategoriesLoader = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;
  final targetAudience = ''.obs;
  final totalViews = 0.obs;
  final wishlist = 0.obs;

  final imagesController = Get.put(ProductImagesController());
  final attributesController = Get.put(ProductAttributesController());
  final variationsController = Get.put(ProductVariationsController());
  final specificationsController = Get.put(ProductSpecificationsController());

  final stockPriceFormKey = GlobalKey<FormState>();
  final productRepository = Get.put(ProductRepository());
  final titleDescriptionFormKey = GlobalKey<FormState>();

  // Text Editing Controllers for input fields
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();
  TextEditingController tags = TextEditingController();

  // Rx Observables for selecting Brand and categories
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final Rx<SizeGuideModel?> selectedSizeGuide = Rx<SizeGuideModel?>(null);
  final Rx<CouponModel?> selectedCoupon = Rx<CouponModel?>(null);
  Rx<BannerModel?> selectedBanner = Rx<BannerModel?>(null);

  // Flags for tracking different tasks
  RxBool thumbnailUploader = true.obs;
  RxBool additionalImagesUploader = false.obs;
  RxBool productDataUploader = true.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  void initProductData(ProductModel product){
    try{
      isLoading.value = true; // Set loading state while initialing data

      // Basic Information
      title.text = product.title;
      description.text = product.description ?? '';
      productType.value = product.productType == ProductType.single.toString() ? ProductType.single : ProductType.variable;

      // Initialize product specifications
      if (product.specifications != null) {
        loadProductSpecifications(product.specifications!);
      } else {
        specificationsController.resetValues();
      }
      
      // Load Target Audience
      targetAudience.value = product.targetAudience;

      // Set isFeatured value
      isFeatured.value = product.isFeatured ?? false;

      // Stock & Pricing (assuming productType and productVisibility are handled elsewhere)
      if(product.productType == ProductType.single.toString()){
        stock.text = product.stock.toString();
        price.text = product.price.toString();
        salePrice.text = product.salePrice.toString();
      }

      // Initialize Tags for Product using TagController
      if (product.tags != null) {
        final tagController = Get.put(TagController());
        tagController.setInitialTags(List<String>.from(product.tags!));
      }

      // Product Brand
      selectedBrand.value = product.brand;
      brandTextField.text = product.brand?.name ?? '';

      //Product Thumbnail and images
      if(product.images != null){
        // Set the first image as thumbnail
        imagesController.selectedThumbnailImageUrl.value = product.thumbnail;

        // Add the images to additional product urls
        imagesController.additionalProductImageUrls.assignAll(product.images ?? []);
      }

      // product attributes & variations (assuming  method to fetch variations in ProductVariationsController)
       attributesController.productAttributes.assignAll(product.productAttributes ?? []);
       variationsController.productVariations.assignAll(product.productVariations ?? []);
       variationsController.initializeVariationsControllers(product.productVariations ?? []);

      isLoading.value = false; // Set loading state to back after initialization

      update();
    } catch(e){
      if(kDebugMode) print(e);
    }
  }

  // Method to load product specifications
  void loadProductSpecifications(ProductSpecifications specs) {
    // Directly use the setSpecifications method from the specifications controller
    specificationsController.setSpecifications(specs);
  }

  // Method to get product specifications from controller
  ProductSpecifications getProductSpecifications() {
    return specificationsController.getSpecifications();
  }

// Function to load a selected category (now only one category can be selected)
  Future<CategoryModel> loadSelectedCategory(String productId) async {
    selectedCategoriesLoader.value = true;

    // Get product categories
    final productCategories = await productRepository.getProductCategories(productId);

    final categoriesController = Get.put(CategoryController());

    // Check if the categories are already loaded
    if (categoriesController.allItems.isEmpty) {
      await categoriesController.fetchItems();
    } else {
    }

    // Try to find the category matching one of the product categories
    try {
      final category = categoriesController.allItems.firstWhere(
            (category) => productCategories.map((e) => e.categoryId).contains(category.name),
        orElse: () {
          // Handle the case where no category is found
          throw Exception("No matching category found for product with ID: $productId");
        },
      );

      // Successfully found a category

      selectedCategory.value = category;

      selectedCategoriesLoader.value = false;
      return category;
    } catch (e) {
      rethrow;
    }
  }

  Future<CouponModel> loadSelectedCoupon(String productId) async {
    selectedCategoriesLoader.value = true;

    try {
      // Get product coupon
      final productCoupon = await productRepository.getProductCoupon(productId);

      // Get the coupon controller (assuming you have one)
      final couponController = Get.put(CouponController());

      // Check if the coupons are already loaded
      if (couponController.allItems.isEmpty) {
        await couponController.fetchItems();
      }

      // Try to find the coupon matching the product coupon
      if (productCoupon != null) {
        final coupon = couponController.allItems.firstWhere(
              (coupon) => coupon.id == productCoupon.id,
          orElse: () {
            // Handle the case where no coupon is found
            throw Exception("No matching coupon found for product with ID: $productId");
          },
        );

        // Successfully found a coupon
        selectedCoupon.value = coupon;

        selectedCategoriesLoader.value = false;
        return coupon;
      } else {
        // If no coupon is associated with the product
        selectedCoupon.value = null;
        selectedCategoriesLoader.value = false;
        throw Exception("No coupon associated with product ID: $productId");
      }
    } catch (e) {
      selectedCategoriesLoader.value = false;
      rethrow;
    }
  }

  Future<BannerModel?> loadBannerForProduct(String productId) async {
    try {
      // Get product banner from repository
      final productBanner = await productRepository.getProductBanner(productId);

      // Get the banner controller
      final bannerController = Get.put(BannerController());

      // Check if banners are already loaded
      if (bannerController.allItems.isEmpty) {
        await bannerController.fetchItems();
      }

      // If a banner is associated with the product, find the matching one in controller
      if (productBanner != null) {
        try {
          final banner = bannerController.allItems.firstWhere(
                (banner) => banner.id == productBanner.id,
            orElse: () {
              print("No matching banner found in controller for ID: ${productBanner.id}");
              // Must return a BannerModel, not null
              throw Exception("Banner not found in controller");
            },
          );

          // Set it as selected banner
          selectedBanner.value = banner;
          print("Banner loaded and matched: ${banner.value}");
          return banner;
        } catch (e) {
          print("Error finding matching banner: $e");
          selectedBanner.value = null;
          return null;
        }
      } else {
        // No banner associated with product
        print("No banner found for product ID: $productId");
        selectedBanner.value = null;
        return null;
      }
    } catch (e) {
      print("[ProductController] Error loading banner: $e");
      selectedBanner.value = null;
      return null;
    }
  }

  void updateCategory(ProductModel product, String selectedCategoryId) async {

    try {
      final oldCategoryId = product.categoryId ?? ''; // Ensure it's not null
      final newCategoryId = selectedCategoryId.trim(); // Get the selected category ID

      // First check if there's actually a change in category
      if (oldCategoryId == newCategoryId) {
        return;
      }

      // Get existing product categories to verify current relationships
      final existingCategories = await productRepository.getProductCategories(product.id);
      final hasExistingCategory = existingCategories.any((cat) => cat.categoryId == oldCategoryId);

      // Only delete if the old category relationship actually exists
      if (hasExistingCategory && oldCategoryId.isNotEmpty) {
        await ProductRepository.instance.deleteProductCategory(product.id, oldCategoryId);
      }

      // Create new category relationship if it doesn't exist
      if (!existingCategories.any((cat) => cat.categoryId == newCategoryId)) {
        final productCategory = ProductCategoryModel(
            productId: product.id,
            categoryId: newCategoryId
        );
        await ProductRepository.instance.createProductCategory(productCategory);
      }

      // Update the product's category ID
      product.categoryId = newCategoryId;
    } catch (e) {
      RSLoaders.errorSnackBar(title: 'Error', message: e.toString());
      rethrow;
    }
  }

  // Function to Update a  Product
  Future<void> updateProduct(ProductModel product) async {
    try {
      // Show progress dialog
      showProgressDialog();

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!titleDescriptionFormKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Validate stock and pricing form if product type = single
      if (productType.value == ProductType.single && !stockPriceFormKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Ensure a brand is selected
      if (selectedBrand.value == null) {
        throw 'Select a Brand for this Product';
      }

      // Ensure a category is selected
      if (selectedCategory.value == null) {
        throw 'Select a Category for this Product';
      }

      // Update category if it's changed
      updateCategory(product, selectedCategory.value!.id);

      // Update target audience
      product.targetAudience = targetAudience.value;

      double singlePrice = double.tryParse(price.text.trim()) ?? 0;
      double singleSalePrice = double.tryParse(salePrice.text.trim()) ?? 0;
      int singleStock = int.tryParse(stock.text.trim()) ?? 0;

      // Check variation data if productType = variable
      if (productType.value == ProductType.variable) {
        if (ProductVariationsController.instance.productVariations.isEmpty) {
          throw 'There are no Variations for the Product type Variable. Create some variations or change Product Type';
        }

        final variationCheckFailed = ProductVariationsController.instance.productVariations.any((element) =>
        element.price.isNaN ||
            element.price < 0 ||
            element.salePrice.isNaN ||
            element.salePrice < 0 ||
            element.stock.isNaN ||
            element.stock < 0 ||
            element.images.isEmpty);

        if (variationCheckFailed) {
          throw 'Variation data is not correct. Please recheck variations.';
        }

        // If single price is 0, calculate from variations
        if (singlePrice == 0) {
          final variations = ProductVariationsController.instance.productVariations;
          if (variations.isNotEmpty) {
            // Find the minimum price from variations
            singlePrice = variations
                .map((variation) => variation.price)
                .reduce((min, price) => price < min ? price : min);

            // Update the price text controller
            price.text = singlePrice.toString();
          }
        }

        // If single sale price is 0, calculate from variations
        if (singleSalePrice == 0) {
          final variations = ProductVariationsController.instance.productVariations;
          if (variations.isNotEmpty) {
            // Find the minimum sale price from variations
            singleSalePrice = variations
                .where((variation) => variation.salePrice > 0)
                .map((variation) => variation.salePrice)
                .fold(0, (min, price) => min == 0 || price < min ? price : min);

            // Update the sale price text controller if a valid sale price was found
            if (singleSalePrice > 0) {
              salePrice.text = singleSalePrice.toString();
            }
          }
          // If single stock is 0, calculate total stock from variations
          if (singleStock == 0) {
            // Sum up all variation stocks
            singleStock = variations
                .map((variation) => variation.stock)
                .fold(0, (sum, stock) => sum + stock);

            // Update the stock text controller
            stock.text = singleStock.toString();
          }
        }
      }

      // Upload Product Thumbnail Image
      thumbnailUploader.value = true;
      final imagesController = ProductImagesController.instance;
      if (imagesController.selectedThumbnailImageUrl.value?.isEmpty ?? true) {
        throw 'Select Product Thumbnail Image';
      }

      // Handle Product Variations
      var variations = ProductVariationsController.instance.productVariations;
      if (productType.value == ProductType.single && variations.isNotEmpty) {
        ProductVariationsController.instance.resetAllValues();
        variations.value = [];
      }

      final specifications = specificationsController.getSpecifications();

      // Map Product Data to Product Model safely
      product
        ..sku = ''
        ..title = title.text.trim()
        ..isFeatured = isFeatured.value
        ..categoryId = selectedCategory.value!.id
        ..categoryName = selectedCategory.value!.name
        ..categorySlug = selectedCategory.value!.slug
        ..description = description.text.trim()
        ..productType = productType.value.toString()
        ..targetAudience = targetAudience.value
      // Handle optional fields safely
        ..coupon = selectedCoupon.value?.title
        ..stock = singleStock
        ..price = singlePrice
        ..salePrice = singleSalePrice
        ..images = imagesController.additionalProductImageUrls
        ..thumbnail = imagesController.selectedThumbnailImageUrl.value ?? ''
        ..productAttributes = ProductAttributesController.instance.productAttributes
        ..productVariations = variations
        ..specifications = specifications
        ..tags = TagController.instance.selectedTags
        ..updatedAt =  DateTime.now();

      productDataUploader.value = true;
      await ProductRepository.instance.updateProduct(product);

      // Register product categories if any
      categoriesRelationshipUploader.value = true;
      final productCategory = ProductCategoryModel(
          productId: product.id,
          categoryId: selectedCategory.value!.name
      );
      await ProductRepository.instance.createProductCategory(productCategory);

      // Update the Product List
      ProductController.instance.updateItemFromLists(product);

      // Call getSimilarProductsByScore to update similar products after the product update
      try {
        final similarProductController = Get.put(SimilarProductController());
        await similarProductController.updateSimilaritiesAfterProductChange(product);
        print('✅ Similar products updated for product ID: ${product.id}');
      } catch (e) {
        print('❌ Error updating similar products: $e');
        // Don't throw here to allow the product update to complete successfully
      }


      resetValues();

      // Close the progress loader
      RSFullScreenLoader.stopLoading();

      // Show success message loader
      showCompletionDialog();
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<void> productViews(ProductModel product) async {
    try {
      print("🔄 Fetching total views...");

      int views = await productRepository.fetchTotalViews(product.id);

      totalViews.value = views;

      print("✅ Total views updated: $views");
    } catch (e) {
      print("❌ Error fetching total views: $e");
    }
  }

  Future<void> wishlistViews(ProductModel product) async {
    try {
      print("🔄 Fetching total views...");

      int views = await productRepository.getWishlistCount(product.id);

      wishlist.value = views;

      print("✅ Total views updated: $views");
    } catch (e) {
      print("❌ Error fetching total views: $e");
    }
  }


  void resetValues(){
    isLoading.value = false;
    isFeatured.value = false;
    productType.value = ProductType.single;
    productVisibility.value = ProductVisibility.hidden;
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    selectedBrand.value = null;
    selectedCategory.value = null;
    selectedCoupon.value = null;
    tags.clear();
    ProductVariationsController.instance.resetAllValues();
    ProductAttributesController.instance.resetProductAttributes();

    // Reset Upload flags
    thumbnailUploader.value  = false;
    additionalImagesUploader.value = false;
    productDataUploader.value = false;
    categoriesRelationshipUploader.value = false;
  }

  // Show progress Dialog
  void showProgressDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Creating Product'),
            content: Obx(
                    () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(RSImages.creatingProductIllustration, height: 200,width: 200),
                    SizedBox(height: RSSizes.spaceBtwItems),
                    buildCheckBox('ThumbnailImage', thumbnailUploader),
                    buildCheckBox('Additional Images', additionalImagesUploader),
                    buildCheckBox('Product Data, Attributes & variations', productDataUploader),
                    buildCheckBox('Product Categories', categoriesRelationshipUploader),
                    SizedBox(height: RSSizes.spaceBtwItems),
                    Text('Sit Tight, Your Product is Uploading....'),
                  ],
                )
            ),
          )),
    );
  }

  Widget buildCheckBox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(duration: Duration(seconds: 2),
          child: value.value
              ? Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.blue)
              : Icon(CupertinoIcons.checkmark_alt_circle)  ,
        ),
        SizedBox(width: RSSizes.spaceBtwItems),
        Text(label),
      ],
    );
  }

  void showCompletionDialog() {
    Get.dialog(
        AlertDialog(
          title: Text('Congratulations'),
          actions: [
            TextButton(
                onPressed: (){
                  Get.back();
                  Get.back();
                  resetValues();
                }, child: Text('Go to Products'))
          ],
          content: Column(
            children: [
              Image.asset(RSImages.productsIllustration, height: 200, width: 200),
              SizedBox(height: RSSizes.spaceBtwItems),
              Text('Congratulations', style: Theme.of(Get.context!).textTheme.headlineSmall),
              SizedBox(height: RSSizes.spaceBtwItems),
              Text('Your Product Has Been Updated'),
            ],
          ),
        )
    );
  }
}