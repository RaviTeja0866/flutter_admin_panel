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

class CreateShopCategoryController extends GetxController {
  static CreateShopCategoryController get instance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final RxString gender = 'Unisex'.obs;
  final formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final shopCategoryRepository = Get.put(ShopCategoryRepository());

  // Pick Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      ImageModel selectedImage = selectedImages.first;
      imageURL.value = selectedImage.url;
    }
  }

  // Create Shop Category
  Future<void> createShopCategory() async {
    try {
      // Start Loading
      RSFullScreenLoader.popUpCircular();

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'No Connection', message: 'Please check your internet connection.');
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Map data
      final newRecord = ShopCategory(
        id: '',
        title: titleController.text.trim(),
        type: typeController.text.trim(),
        imageUrl: imageURL.value,
        gender: gender.value,
        active: isActive.value,
      );

      // Create the shop category in Firestore and get the generated ID
      newRecord.id = await shopCategoryRepository.createShopCategory(newRecord);

      // Update all data list
      ShopCategoryController.instance.addItemToLists(newRecord);

      // Stop loading
      RSFullScreenLoader.stopLoading();

      // Success message
      RSLoaders.successSnackBar(title: 'Congratulations', message: 'New Shop Category has been Added');
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
