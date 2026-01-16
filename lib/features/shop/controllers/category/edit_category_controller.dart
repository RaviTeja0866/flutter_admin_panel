import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/category/category_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';

import '../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class EditCategoryController extends GetxController {
  static EditCategoryController get instance => Get.find();

  final _categoryRepository = CategoryRepository.instance;

  /// 🔑 SOURCE OF TRUTH
  final Rxn<CategoryModel> category = Rxn<CategoryModel>();

  final selectedParent = CategoryModel.empty().obs;
  final isFeatured = false.obs;
  final imageURL = ''.obs;

  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _loaded = false;

  // ---------------------------------------------------------------------------
  // LOAD CATEGORY BY ID (WEB SAFE)
  // ---------------------------------------------------------------------------
  Future<void> loadCategory(String categoryId) async {
    if (_loaded) return;
    _loaded = true;

    final data = await _categoryRepository.getById(categoryId);
    category.value = data;

    // Init fields
    name.text = data.name;
    isFeatured.value = data.isFeatured;
    imageURL.value = data.image;

    if (data.parentId.isNotEmpty) {
      final parent = CategoryController.instance.allItems
          .firstWhereOrNull((c) => c.id == data.parentId);

      if (parent != null) {
        selectedParent.value = parent;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE CATEGORY
  // ---------------------------------------------------------------------------
  Future<void> updateCategory() async {
    await ActionGuard.run(
        permission: Permission.categoryUpdate,
        showDeniedScreen: true,
        action: () async {
      try {
        RSFullScreenLoader.popUpCircular();

        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        if (!formKey.currentState!.validate()) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        final item = category.value!;
        item
          ..name = name.text.trim()
          ..image = imageURL.value
          ..parentId = selectedParent.value.id
          ..isFeatured = isFeatured.value
          ..updatedAt = DateTime.now();

        await _categoryRepository.updateCategory(item);

        CategoryController.instance.updateItemFromLists(item);

        RSFullScreenLoader.stopLoading();
        RSLoaders.success(message: 'Category Updated Successfully');
        resetFields();
        Get.offNamed(RSRoutes.categories);
      } catch (e) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.error(
          message: e.toString(),
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // PICK IMAGE
  // ---------------------------------------------------------------------------
  void pickImage() async {
    final controller = Get.put(MediaController());
    final images = await controller.selectImagesFromMedia();

    if (images != null && images.isNotEmpty) {
      imageURL.value = images.first.url;
    }
  }

  void resetFields() {
    name.clear();
    imageURL.value = '';
    isFeatured.value = false;
    selectedParent.value = CategoryModel.empty();
    category.value = null;
    _loaded = false;
  }

}
