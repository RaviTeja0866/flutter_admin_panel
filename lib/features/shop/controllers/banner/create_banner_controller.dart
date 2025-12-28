import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:roguestore_admin_panel/data/repositories/banner/banner_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';

import '../../../../common/widgets/appScreen/app_screen.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class CreateBannerController extends GetxController {
  static CreateBannerController get instance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final RxString targetScreen = AppScreens.allAppScreensItems[0].obs;
  final formKey = GlobalKey<FormState>();

  // New Fields for Dynamic Banner Types
  final RxString bannerType = 'category'.obs; // 'category' or 'offer'
  final RxString bannerValue = ''.obs; // Category name or offer name
  final RxInt priority = 1.obs; // Priority level of the banner
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Date Controllers
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final bannerRepo = Get.put(BannerRepository());
  final bannerController = Get.put(BannerController());

  // Pick Thumbnail Image from Media
  void pickImage() async {
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    // Handle the selected Images images
    if (selectedImages != null && selectedImages.isNotEmpty) {
      // set the selectedImage to the main image or perform any other action
      ImageModel selectedImage = selectedImages.first;
      //update the main image using the selectedImage
      imageURL.value = selectedImage.url;
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked;
      startDateController.text = "${picked.toLocal()}".split(' ')[0];
    } else {
    }
  }

  Future<void> selectExpiryDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      endDate.value = picked;
      endDateController.text = "${picked.toLocal()}".split(' ')[0];
    } else {
    }
  }

  //Register New Banner
  Future<void> createBanner() async {
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

      if (startDate.value == null || endDate.value == null) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Validation Error', message: 'Please fill all required fields.');
        return;
      }

      if (startDate.value!.isAfter(endDate.value!)) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Date Error', message: 'Start date cannot be after expiry date.');
        return;
      }

      //Map data
      final newRecord = BannerModel(
        id: '',
        targetScreen: targetScreen.value,
        active: isActive.value,
        imageUrl: imageURL.value,
        type: bannerType.value,
        value: bannerValue.value,
        startDate: DateTime.parse(startDateController.text),
        endDate: DateTime.parse(endDateController.text),
      );

      // Create the brand in Firestore and get the generated ID
      newRecord.id = await bannerRepo.createBanner(newRecord);

      //Update all data list
      bannerController.addItemToLists(newRecord);

      //Remove loading
      RSFullScreenLoader.stopLoading();

      //Success message
      RSLoaders.successSnackBar(
          title: 'Congratulations', message: 'New Banner has been Added');
    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

}
