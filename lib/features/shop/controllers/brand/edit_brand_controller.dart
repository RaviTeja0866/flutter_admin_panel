import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/brand/brand_repository.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/brand_category.dart';
import 'package:roguestore_admin_panel/features/shop/models/brand_model.dart';
import 'package:roguestore_admin_panel/utils/helpers/network_manager.dart';
import 'package:roguestore_admin_panel/utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/category_model.dart';

class EditBrandController extends GetxController {
  static EditBrandController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BrandRepository());
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  // Init Data
  void init(BrandModel brand) {
      name.text = brand.name;
      imageURL.value = brand.image;
      isFeatured.value = brand.isFeatured;
      if (brand.brandCategories != null) {
        selectedCategories.addAll(brand.brandCategories ?? []);
      }
  }

  // Toggle Category Selection
  void toggleSelection(CategoryModel category) {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
  }

  // Method to reset Fields
  void resetFields() {
      name.clear();
      loading(false);
      isFeatured(false);
      imageURL.value = '';
      selectedCategories.clear();
  }

  // Pick Thumbnail Image from Media
  void pickImage() async {
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

      if (selectedImages != null && selectedImages.isNotEmpty) {
        ImageModel selectedImage = selectedImages.first;
        imageURL.value = selectedImage.url;
      }
  }

  // Update new Brand
  Future<void> updateBrand(BrandModel brand) async {
    try {

      RSFullScreenLoader.popUpCircular();

      // Check Network Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your connection.');
        return;
      }

      // Validate Form
      if (!formKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Oh Snap', message: 'Form validation failed.');
        return;
      }


      bool isBrandUpdated = false;
      if (brand.image != imageURL.value || brand.name != name.text.trim() || brand.isFeatured != isFeatured.value) {
        isBrandUpdated = true;

        brand.image = imageURL.value;
        brand.name = name.text.trim();
        brand.isFeatured = isFeatured.value;
        brand.updatedAt = DateTime.now();
        await repository.updateBrand(brand);
      }

      // Update Brand Categories
      if (selectedCategories.isNotEmpty) await updateBrandCategories(brand);

      // Update Brand in Products
      if (isBrandUpdated) await updateBrandInProducts(brand);

      // Notify Success
      BrandController.instance.updateItemFromLists(brand);

      update();

      RSFullScreenLoader.stopLoading();
      RSLoaders.successSnackBar(title: 'Congratulations', message: 'Brand has been updated successfully.');
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }


  Future<void> updateBrandCategories(BrandModel brand) async {

      // Fetch all BrandCategories
      final brandCategories = await repository.getCategoriesOfSpecificBrand(brand.id);

      // SelectCategoryIds
      final selectedCategoryIds = selectedCategories.map((e) => e.id);

      // Identify Categories to remove
      final categoriesToRemove = brandCategories.where((existingCategory) => !selectedCategoryIds.contains(existingCategory.categoryId)).toList();

      // Remove Unselected Categories
      for (var categoryToRemove in categoriesToRemove) {
        await BrandRepository.instance.deleteBrandCategory(categoryToRemove.id ?? '');
      }

      // Identify new Categories to add
      final newCategoriesToAdd = selectedCategories.where((newCategory) => !brandCategories.any((existingCategory) => existingCategory.categoryId == newCategory.id)).toList();

      // Add new Categories
      for (var newCategory in newCategoriesToAdd) {
        var brandCategory = BrandCategoryModel(brandId: brand.id, categoryId: newCategory.id);
        brandCategory.id = await BrandRepository.instance.createBrandCategory(brandCategory);
      }
    }


  Future<void> updateBrandInProducts(BrandModel brand) async {
    try {
      // Your logic for updating the brand in products
    } catch (e) {
    }
  }
}
