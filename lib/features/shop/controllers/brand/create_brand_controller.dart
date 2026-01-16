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

import '../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/category_model.dart';

class CreateBrandController extends GetxController{
  static CreateBrandController get instance => Get.find();

  final loading = false.obs;
  RxString imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final repository = BrandRepository.instance;
  final List<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  // Toggle Category Selection
  void toggleSelection(CategoryModel category){
    if(selectedCategories.contains(category)){
      selectedCategories.remove(category);
    } else{
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
  void pickImage() async{
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected Images images
    if(selectedImages !=null && selectedImages.isNotEmpty){
      // set the selectedImage to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;
      //update the main image using the selectedImage
      imageURL.value = selectedImage.url;
    }
  }


  Future<void> createBrand() async {
    await ActionGuard.run(
        permission: Permission.brandCreate,
        showDeniedScreen: true,
        action: () async {
      try {
        // Start Loading
        RSFullScreenLoader.popUpCircular();

        // Check internet connectivity
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        // Form Validation
        if (!formKey.currentState!.validate()) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        // Map Data for new Brand
        final newRecord = BrandModel(
          id: '',
          // Leave the ID empty; it will be generated after adding to Firestore
          productsCount: 0,
          image: imageURL.value,
          name: name.text.trim(),
          createdAt: DateTime.now(),
          isFeatured: isFeatured.value,
        );

        // Create the brand in Firestore and get the generated ID
        newRecord.id = await repository.createBrand(newRecord);


        // Check if the ID is successfully set
        if (newRecord.id.isEmpty) {
          throw 'Error generating brand ID';
        }

        // Register brand categories if any
        if (selectedCategories.isNotEmpty) {
          if (newRecord.id
              .isEmpty) throw 'Error storing relational data. Try again.';

          // Loop through the selected Brand Categories
          for (var category in selectedCategories) {
            // Map Data for BrandCategory
            final brandCategory = BrandCategoryModel(
              brandId: newRecord.id,
              categoryId: category.id,
              id: '',
            );
            await repository.createBrandCategory(brandCategory);
          }
          newRecord.brandCategories ??= [];
          newRecord.brandCategories!.addAll(selectedCategories);
        }

        // Update the brand list with the new record
        BrandController.instance.addItemToLists(newRecord);

        // Reset form fields
        resetFields();

        // Stop the loading indicator
        RSFullScreenLoader.stopLoading();

        // Show success message and optional redirect
        RSLoaders.success(message: 'New Brand Has Been Added');
        Get.offNamed(RSRoutes.brands);
      } catch (e) {
        // Stop the loading indicator in case of an error
        RSFullScreenLoader.stopLoading();
        RSLoaders.error(message: e.toString());
      }
    });
  }





}