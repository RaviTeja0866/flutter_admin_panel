import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/category/category_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  final isFeatured = false.obs;
  RxString imageURL = ''.obs;

  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // -------------------------
  // Init Data
  // -------------------------
  void init(CategoryModel category) {
    name.text = category.name;
    isFeatured.value = category.isFeatured;
    imageURL.value = category.image;

    if (category.parentId.isNotEmpty) {
      selectedParent.value = CategoryController.instance.allItems
          .firstWhere((c) => c.id == category.parentId);
    }
  }

  // -------------------------
  // Update Category
  // -------------------------
  Future<void> updateCategory(CategoryModel category) async {
    try {
      RSFullScreenLoader.popUpCircular();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      if (!formKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(
            title: 'Oh Snap', message: 'Form validation failed.');
        return;
      }

      // Update ONLY allowed fields
      category.name = name.text.trim();
      category.image = imageURL.value;
      category.parentId = selectedParent.value.id;
      category.isFeatured = isFeatured.value;
      category.updatedAt = DateTime.now();

      await CategoryRepository.instance.updateCategory(category);

      CategoryController.instance.updateItemFromLists(category);

      resetFields();

      RSFullScreenLoader.stopLoading();
      RSLoaders.successSnackBar(
        title: 'Success',
        message: 'Category updated successfully.',
      );
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // -------------------------
  // Pick Image
  // -------------------------
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages =
    await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageURL.value = selectedImages.first.url;
    }
  }

  // -------------------------
  // Reset
  // -------------------------
  void resetFields() {
    selectedParent(CategoryModel.empty());
    loading(false);
    isFeatured(false);
    name.clear();
    imageURL.value = '';
  }
}
