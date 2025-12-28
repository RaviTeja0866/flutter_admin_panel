import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/shop_category/shop_category_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/shop_category/shop_category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/shop_category.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class EditShopCategoryController extends GetxController {
  static EditShopCategoryController get instance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final gender = 'Men'.obs; // Default value
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(ShopCategoryRepository());

  // Init Data
  void init(ShopCategory shopCategory) {
    imageURL.value = shopCategory.imageUrl;
    isActive.value = shopCategory.active;
    gender.value = shopCategory.gender;
    titleController.text = shopCategory.title;
    typeController.text = shopCategory.type;
  }

  // Pick Thumbnail Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected Images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // set the selectedImage to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;
      //update the main image using the selectedImage
      imageURL.value = selectedImage.url;
    }
  }

  // Update Shop Category
  Future<void> updateShopCategory(ShopCategory shopCategory) async {
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

      // Is data updated
      if (shopCategory.imageUrl != imageURL.value ||
          shopCategory.title != titleController.text ||
          shopCategory.type != typeController.text ||
          shopCategory.gender != gender.value ||
          shopCategory.active != isActive.value) {
        // Map data
        shopCategory.imageUrl = imageURL.value;
        shopCategory.title = titleController.text;
        shopCategory.type = typeController.text;
        shopCategory.gender = gender.value;
        shopCategory.active = isActive.value;

        await repository.updateShopCategory(shopCategory);
      }

      // Update all data list
      ShopCategoryController.instance.updateItemFromLists(shopCategory);

      // Remove loading
      RSFullScreenLoader.stopLoading();

      // Success message
      RSLoaders.successSnackBar(title: 'Congratulations', message: 'Shop Category has been Updated');
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
