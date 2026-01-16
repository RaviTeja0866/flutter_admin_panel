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

class EditBrandController extends GetxController {
  static EditBrandController get instance => Get.find();

  final _repository = BrandRepository.instance;

  /// 🔑 SOURCE OF TRUTH
  final Rxn<BrandModel> brand = Rxn<BrandModel>();

  final loading = false.obs;
  final imageURL = ''.obs;
  final isFeatured = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final selectedCategories = <CategoryModel>[].obs;

  bool _loaded = false;

  // ---------------------------------------------------------------------------
  // LOAD BRAND BY ID (REFRESH SAFE)
  // ---------------------------------------------------------------------------
  Future<void> loadBrand(String brandId) async {
    if (_loaded) return;
    _loaded = true;

    loading(true);

    final data = await _repository.getBrandById(brandId);
    brand.value = data;

    name.text = data.name;
    imageURL.value = data.image;
    isFeatured.value = data.isFeatured;

    selectedCategories.clear();
    if (data.brandCategories != null) {
      selectedCategories.addAll(data.brandCategories!);
    }

    loading(false);
  }

  // ---------------------------------------------------------------------------
  // TOGGLE CATEGORY
  // ---------------------------------------------------------------------------
  void toggleSelection(CategoryModel category) {
    selectedCategories.contains(category)
        ? selectedCategories.remove(category)
        : selectedCategories.add(category);
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

  // ---------------------------------------------------------------------------
  // UPDATE BRAND
  // ---------------------------------------------------------------------------
  Future<void> updateBrand() async {
    await ActionGuard.run(
        permission: Permission.brandUpdate,
        showDeniedScreen: true,
        action: () async {
      try {
        RSFullScreenLoader.popUpCircular();

        // -----------------------
        // Network check
        // -----------------------
        final isConnected = await NetworkManager.instance.isConnected();

        if (!isConnected) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        // -----------------------
        // Form validation
        // -----------------------
        final isValid = formKey.currentState?.validate() ?? false;

        if (!isValid) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        // -----------------------
        // Brand object check
        // -----------------------
        final item = brand.value;
        if (item == null) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        // -----------------------
        // Assign new values
        // -----------------------
        item
          ..name = name.text.trim()
          ..image = imageURL.value
          ..isFeatured = isFeatured.value
          ..updatedAt = DateTime.now();

        // -----------------------
        // Firestore update
        // -----------------------
        await _repository.updateBrand(item);

        // -----------------------
        // Brand categories
        // -----------------------
        await updateBrandCategories(item);
        print('✅ Brand categories updated');

        // -----------------------
        // Local state update
        // -----------------------
        BrandController.instance.updateItemFromLists(item);

        // -----------------------
        // Finish
        // -----------------------
        RSFullScreenLoader.stopLoading();
        RSLoaders.success(message: 'Brand updated successfully');

        resetFields();

        Get.offNamed(RSRoutes.brands);
      } catch (e, stack) {
        RSFullScreenLoader.stopLoading();
        print('Error: $e');
        print('StackTrace: $stack');

        RSLoaders.error(
          message: e.toString(),
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // BRAND CATEGORIES
  // ---------------------------------------------------------------------------
  Future<void> updateBrandCategories(BrandModel brand) async {
    final existing = await _repository.getCategoriesOfSpecificBrand(brand.id);
    final selectedIds = selectedCategories.map((e) => e.id).toSet();

    for (final old in existing) {
      if (!selectedIds.contains(old.categoryId)) {
        await _repository.deleteBrandCategory(old.id ?? '');
      }
    }

    for (final category in selectedCategories) {
      if (!existing.any((e) => e.categoryId == category.id)) {
        final bc = BrandCategoryModel(
          brandId: brand.id,
          categoryId: category.id,
        );
        bc.id = await _repository.createBrandCategory(bc);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // CLEANUP
  // ---------------------------------------------------------------------------
  void resetFields() {
    name.clear();
    imageURL.value = '';
    isFeatured.value = false;
    selectedCategories.clear();
    brand.value = null;
    _loaded = false;
  }
}
