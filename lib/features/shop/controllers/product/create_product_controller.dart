import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/product/product_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_attributes_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_images_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_variations_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/similar_product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/specifications_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/tag/create_and_update_tag_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/brand_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_category_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/size_guide_model.dart';

import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import '../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();

  // Obx for loading state and Product details
  final isLoading = false.obs;
  final isFeatured = false.obs;
  final productType = ProductType.single.obs;
  final productVisibility = ProductVisibility.hidden.obs;
  final targetAudience = Rx<String?>('Unisex');
  final productController = Get.put(ProductController());

  // Controller nd Keys
  final stockPriceFormKey = GlobalKey<FormState>();
  final productRepository = ProductRepository.instance;
  final titleDescriptionFormKey = GlobalKey<FormState>();
  final specificationsFormKey = GlobalKey<FormState>();

  // Text Editing Controllers for input fields
  TextEditingController title = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController brandTextField = TextEditingController();

  // Rx Observables for selecting Brand and categories
  final Rx<BrandModel?> selectedBrand = Rx<BrandModel?>(null);

  // Rx Observable for selecting a single category
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  // RxList for storing selected tags
  final RxList<String> selectedTags = <String>[].obs;

  final Rx<SizeGuideModel?> selectedSizeGuide = Rx<SizeGuideModel?>(null);
  final Rx<CouponModel?> selectedCoupon = Rx<CouponModel?>(null);
  final Rx<BannerModel?> selectedBanner = Rx<BannerModel?>(null);

  // Flags for tracking different tasks
  RxBool thumbnailUploader = false.obs;
  RxBool additionalImagesUploader = false.obs;
  RxBool productDataUploader = false.obs;
  RxBool categoriesRelationshipUploader = false.obs;

  // Add this property to your CreateProductController class
  final similarityScoring = RxBool(false);

  // Function to Create a new Product
  Future<void> createProduct() async {
    await ActionGuard.run(
        permission: Permission.productCreate,
        showDeniedScreen: true,
        action: () async {
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

            // Validate specifications form
            final specificationsController =
                Get.put(ProductSpecificationsController());
            if (!specificationsController.formKey.currentState!.validate()) {
              RSFullScreenLoader.stopLoading();
              return;
            }

            // Get variable prices if product type is variable
            double singlePrice = double.tryParse(price.text.trim()) ?? 0;
            double singleSalePrice =
                double.tryParse(salePrice.text.trim()) ?? 0;
            int singleStock = int.tryParse(stock.text.trim()) ?? 0;

            if (productType.value == ProductType.variable) {
              if (ProductVariationsController
                  .instance.productVariations.isEmpty) {
                throw 'There are no Variations for the Product type Variable. Create some variations or change Product Type';
              }

              // If single price is 0, calculate from variations
              if (singlePrice == 0) {
                final variations =
                    ProductVariationsController.instance.productVariations;
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
                final variations =
                    ProductVariationsController.instance.productVariations;
                if (variations.isNotEmpty) {
                  // Find the minimum sale price from variations
                  singleSalePrice = variations
                      .where((variation) => variation.salePrice > 0)
                      .map((variation) => variation.salePrice)
                      .fold(
                          0,
                          (min, price) =>
                              min == 0 || price < min ? price : min);

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
            // Validate stock and pricing form if product type = single
            if (productType.value == ProductType.single &&
                !stockPriceFormKey.currentState!.validate()) {
              RSFullScreenLoader.stopLoading();
              return;
            }

            // Ensure a brand is selected
            if (selectedBrand.value == null) {
              throw 'Select a Brand for this Product';
            }

            // Ensure a Category is selected
            if (selectedCategory.value == null) {
              throw 'Select a Category for this Product';
            }

            // Ensure a Size Guide is selected
            if (selectedSizeGuide.value == null) {
              throw 'Select a SizeGuide for this Product';
            }

            // Ensure a Coupon is Selected
            if (selectedCoupon.value == null) {
              throw 'Select a Coupon for this Product';
            }

            // Check variation data if productType = variable
            if (productType.value == ProductType.variable &&
                ProductVariationsController
                    .instance.productVariations.isEmpty) {
              throw 'There are no Variations for the Product type Variable. Create some variations or change Product Type';
            }

            // Ensure a Target Audience is selected
            if (targetAudience.value == null || targetAudience.value!.isEmpty) {
              throw 'Please select a target audience for this product.';
            }

            if (productType.value == ProductType.variable) {
              final variationCheckFailed = ProductVariationsController
                  .instance.productVariations
                  .any((element) =>
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
            }

            // Upload Product Thumbnail Image
            thumbnailUploader.value = true;
            final imagesController = ProductImagesController.instance;
            if (imagesController.selectedThumbnailImageUrl.value == null) {
              throw 'Select Product Thumbnail Image';
            }

            // Additional Product Images
            additionalImagesUploader.value = true;

            // Product Variation Images
            final variations =
                ProductVariationsController.instance.productVariations;
            if (productType.value == ProductType.single &&
                variations.isNotEmpty) {
              ProductVariationsController.instance.resetAllValues();
              variations.value = [];
            }

            // Get specifications from controller
            final specifications = specificationsController.getSpecifications();

            // Map Product Data to Product Model
            final newRecord = ProductModel(
              id: '',
              sku: '',
              isFeatured: isFeatured.value,
              title: title.text.trim(),
              brand: selectedBrand.value,
              categoryId: selectedCategory.value!.id,
              categoryName: selectedCategory.value!.name,
              categorySlug: selectedCategory.value!.slug,
              sizeGuide: selectedSizeGuide.value?.garmentType,
              coupon: selectedCoupon.value?.title,
              offerTag: selectedBanner.value?.value,
              productVariations: variations,
              description: description.text.trim(),
              productType: productType.value.toString(),
              targetAudience: targetAudience.value?.toString() ?? 'Unisex',
              stock: singleStock,
              price: singlePrice,
              images: imagesController.additionalProductImageUrls,
              salePrice: singleSalePrice,
              thumbnail: imagesController.selectedThumbnailImageUrl.value ?? '',
              productAttributes:
                  ProductAttributesController.instance.productAttributes,
              tags: TagController.instance.selectedTags,
              specifications: specifications,
              // Add specifications to the model
              createdAt: DateTime.now(),
            );

            // Call repository to create a New Product
            productDataUploader.value = true;
            newRecord.id = await productRepository.createProduct(newRecord);

            // Register product categories if any
            if (selectedCategory.value != null) {
              final productCategory = ProductCategoryModel(
                  productId: newRecord.id,
                  categoryId: selectedCategory.value!.id);
              await productRepository.createProductCategory(productCategory);
            }

            // Update the Product List
            productController.addItemToLists(newRecord);

            // Score the newly created product against others for similarity
            await _calculateSimilarityScores(newRecord);

            // Close the progress loader
            RSFullScreenLoader.stopLoading();

            // Show success message loader
            showCompletionDialog();

            RSLoaders.success(message: 'Product Has Been Created');
            Get.offNamed(RSRoutes.products);
          } catch (e) {
            // Stop the loading indicator in case of an error
            RSFullScreenLoader.stopLoading();
            RSLoaders.error(message: e.toString());
          }
        });
  }

// Then modify the _calculateSimilarityScores method
  Future<void> _calculateSimilarityScores(ProductModel newProduct) async {
    try {
      // Update UI to show scoring progress
      similarityScoring.value = true;

      // Make sure the SimilarProductController is available
      final similarProductController = Get.put(SimilarProductController());

      // Score the new product against others
      await similarProductController.getSimilarProductsByScore(
        currentProduct: newProduct,
        limit: 10, // Get a good number of similar products
      );

      log('Similarity scores calculated for new product: ${newProduct.id}');
    } catch (e) {
      log('Error calculating similarity scores: $e');
      // Don't throw - we don't want to fail product creation if scoring fails
    } finally {
      similarityScoring.value = false;
    }
  }

  void resetValues() {
    isLoading.value = false;
    isFeatured.value = false;
    productType.value = ProductType.single;
    targetAudience.value = 'Unisex';
    productVisibility.value = ProductVisibility.hidden;
    stockPriceFormKey.currentState?.reset();
    titleDescriptionFormKey.currentState?.reset();
    title.clear();
    description.clear();
    stock.clear();
    price.clear();
    salePrice.clear();
    brandTextField.clear();
    selectedTags.clear();
    selectedBrand.value = null;
    selectedCategory.value = null;
    selectedSizeGuide.value = null;
    selectedCoupon.value = null;
    selectedBanner.value = null;
    ProductVariationsController.instance.resetAllValues();
    ProductAttributesController.instance.resetProductAttributes();

    // Reset Upload flags
    thumbnailUploader.value = false;
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
            content: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(RSImages.creatingProductIllustration,
                        height: 200, width: 200),
                    SizedBox(height: RSSizes.spaceBtwItems),
                    buildCheckBox('Thumbnail Image', thumbnailUploader),
                    buildCheckBox(
                        'Additional Images', additionalImagesUploader),
                    buildCheckBox('Product Data, Attributes & Variations',
                        productDataUploader),
                    buildCheckBox(
                        'Product Categories', categoriesRelationshipUploader),
                    SizedBox(height: RSSizes.spaceBtwItems),
                    Text('Sit Tight, Your Product is Uploading...'),
                  ],
                )),
          )),
    );
  }

  Widget buildCheckBox(String label, RxBool value) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: Duration(seconds: 2),
          child: value.value
              ? Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.blue)
              : Icon(CupertinoIcons.checkmark_alt_circle),
        ),
        SizedBox(width: RSSizes.spaceBtwItems),
        Text(label),
      ],
    );
  }

  void showCompletionDialog() {
    Get.dialog(AlertDialog(
      title: Text('Congratulations'),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              resetValues();
            },
            child: Text('Go to Products'))
      ],
      content: Column(
        children: [
          Image.asset(RSImages.productsIllustration, height: 200, width: 200),
          SizedBox(height: RSSizes.spaceBtwItems),
          Text('Congratulations',
              style: Theme.of(Get.context!).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),
          Text('Your Product Has Been created'),
        ],
      ),
    ));
  }
}
