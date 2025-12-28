import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/category/category_repository.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/utils/helpers/network_manager.dart';
import 'package:roguestore_admin_panel/utils/popups/full_screen_loader.dart';

import '../../../../utils/popups/loaders.dart';
import '../../models/category_model.dart';

class CreateCategoryController extends GetxController {
  static CreateCategoryController get instance => Get.find();

  final selectedParent = CategoryModel.empty().obs;
  final loading = false.obs;
  final isFeatured = false.obs;

  RxString imageURL = ''.obs;

  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // -------------------------
  // Create Category
  // -------------------------
  Future<void> createCategory() async {
    try {
      RSFullScreenLoader.popUpCircular();

      // Check internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Validate form
      if (!formKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      final categoryName = name.text.trim();
      final generatedSlug = _generateSlug(categoryName);

      final newRecord = CategoryModel(
        id: '',
        name: categoryName,
        slug: generatedSlug,
        image: imageURL.value,
        parentId: selectedParent.value.id,
        isFeatured: isFeatured.value,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      newRecord.id =
      await CategoryRepository.instance.createCategory(newRecord);

      // Update local lists
      CategoryController.instance.addItemToLists(newRecord);

      // Reset
      resetFields();

      RSFullScreenLoader.stopLoading();
      RSLoaders.successSnackBar(
        title: 'Congratulations',
        message: 'New category has been added.',
      );
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  // -------------------------
  // Slug Generator
  // -------------------------
  String _generateSlug(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
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
  // Reset Form
  // -------------------------
  void resetFields() {
    selectedParent(CategoryModel.empty());
    loading(false);
    isFeatured(false);
    name.clear();
    imageURL.value = '';
  }
}
