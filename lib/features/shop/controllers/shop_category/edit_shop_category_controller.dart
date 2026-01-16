import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/shop_category/shop_category_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/shop_category/shop_category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/shop_category.dart';

import '../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class EditShopCategoryController extends GetxController {
  static EditShopCategoryController get instance => Get.find();

  final repository = Get.find<ShopCategoryRepository>();

  final Rxn<ShopCategory> category = Rxn<ShopCategory>();

  final imageURL = ''.obs;
  final isActive = false.obs;
  final gender = 'Men'.obs;
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _loaded = false;

  // 🔑 LOAD CATEGORY BY ID (WEB SAFE)
  Future<void> loadCategory(String id) async {
    if (_loaded) return;
    _loaded = true;

    final data = await repository.getById(id);
    category.value = data;

    imageURL.value = data.imageUrl;
    isActive.value = data.active;
    gender.value = data.gender;
    titleController.text = data.title;
    typeController.text = data.type;
  }

  // Pick Thumbnail Image
  void pickImage() async {
    final controller = Get.put(MediaController());
    final selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageURL.value = selectedImages.first.url;
    }
  }

  // Update Shop Category
  Future<void> updateShopCategory() async {
    await ActionGuard.run(
        permission: Permission.shopCategoryUpdate,
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
          ..imageUrl = imageURL.value
          ..title = titleController.text
          ..type = typeController.text
          ..gender = gender.value
          ..active = isActive.value;

        await repository.updateShopCategory(item);
        ShopCategoryController.instance.updateItemFromLists(item);

        RSFullScreenLoader.stopLoading();

        RSLoaders.success(message: 'Shop Category has been Updated');
        Get.offNamed(RSRoutes.shopCategory);
      } catch (e) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.error(
          message: e.toString(),
        );
      }
    });
  }
}
