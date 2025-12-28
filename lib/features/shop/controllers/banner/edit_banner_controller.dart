import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/banner/banner_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../media/controllers/media_controller.dart';
import '../../../media/models/image_model.dart';

class EditBannerController extends GetxController{
  static EditBannerController get instance => Get.find();

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final targetScreen = ''.obs;
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BannerRepository());

  // New Fields for Dynamic Banner Types
  final RxString bannerType = 'category'.obs;
  final RxString bannerValue = ''.obs;
  final RxInt priority = 1.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Date Controllers
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final TextEditingController bannerValueController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  // Init Data
  void init(BannerModel banner){
    print("Initializing banner data...");
    imageURL.value = banner.imageUrl;
    isActive.value = banner.active;
    targetScreen.value = banner.targetScreen;
    bannerType.value = banner.type;
    bannerValue.value = banner.value;
    startDate.value = banner.startDate;
    endDate.value = banner.endDate;

    bannerValueController.text = banner.value;

    if (banner.startDate != null) {
      startDateController.text = "${banner.startDate!.toLocal()}".split(' ')[0];
    }
    if (banner.endDate != null) {
      endDateController.text = "${banner.endDate!.toLocal()}".split(' ')[0];
    }

    print("Banner Initialized: $banner");
  }

  // Pick Thumbnail Image from Media
  void pickImage() async{
    print("Picking an image from media...");
    final controller = Get.put(MediaController());
    List<ImageModel>? selectedImages = await controller.selectImagesFromMedia();

    if(selectedImages != null && selectedImages.isNotEmpty){
      ImageModel selectedImage = selectedImages.first;
      imageURL.value = selectedImage.url;
      print("Selected Image URL: ${imageURL.value}");
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    print("Selecting start date...");
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked;
      startDateController.text = "${picked.toLocal()}".split(' ')[0];
      print("Start Date Selected: ${startDate.value}");
    }
  }

  Future<void> selectExpiryDate(BuildContext context) async {
    print("Selecting expiry date...");
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      endDate.value = picked;
      endDateController.text = "${picked.toLocal()}".split(' ')[0];
      print("Expiry Date Selected: ${endDate.value}");
    }
  }

  // Update Existing Banner
  Future<void> updateBanner(BannerModel banner) async {
    try{
      print("Updating banner: ${banner.id}");
      RSFullScreenLoader.popUpCircular();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        print("No internet connection.");
        RSFullScreenLoader.stopLoading();
        return;
      }

      if (!formKey.currentState!.validate()) {
        print("Form validation failed.");
        RSFullScreenLoader.stopLoading();
        return;
      }

      if (startDate.value == null || endDate.value == null) {
        print("Validation Error: Start or End date missing.");
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Validation Error', message: 'Please fill all required fields.');
        return;
      }

      if (startDate.value!.isAfter(endDate.value!)) {
        print("Date Error: Start date is after expiry date.");
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Date Error', message: 'Start date cannot be after expiry date.');
        return;
      }

      banner.imageUrl = imageURL.value;
      banner.targetScreen = targetScreen.value;
      banner.active = isActive.value;
      banner.type = bannerType.value;
      banner.value = bannerValue.value;
      banner.startDate = startDate.value!;
      banner.endDate = endDate.value!;

      print("Sending updated banner data to repository...");
      await repository.updateBanner(banner);
      BannerController.instance.updateItemFromLists(banner);
      RSFullScreenLoader.stopLoading();

      print("Banner updated successfully.");
      RSLoaders.successSnackBar(title: 'Success', message: 'Banner updated successfully!');
    } catch (e) {
      print("Error updating banner: $e");
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}