import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/banner/banner_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/banner/banner_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';

import '../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
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
  final repository = BannerRepository.instance;

  // New Fields for Dynamic Banner Types
  final RxString bannerType = 'category'.obs;
  final RxString bannerValue = ''.obs;
  final RxInt priority = 1.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final Rxn<BannerModel> banner = Rxn<BannerModel>();

  // Date Controllers
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final TextEditingController bannerValueController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();

  bool _loaded = false;

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

  Future<void> loadBanner(String bannerId) async {
    if (_loaded) return;
    _loaded = true;

    print('📥 Loading banner: $bannerId');

    final data = await repository.getBannerById(bannerId);
     banner.value = data;

    init(data);
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
  Future<void> updateBanner() async {
    await ActionGuard.run(
        permission: Permission.bannerUpdate,
        showDeniedScreen: true,
        action: () async {
      try {
        print('🟡 [UPDATE BANNER] Started');

        RSFullScreenLoader.popUpCircular();

        final item = banner.value;
        if (item == null) {
          RSFullScreenLoader.stopLoading();
          print('❌ banner.value is NULL');
          return;
        }

        item
          ..imageUrl = imageURL.value
          ..targetScreen = targetScreen.value
          ..active = isActive.value
          ..type = bannerType.value
          ..value = bannerValue.value
          ..startDate = startDate.value!
          ..endDate = endDate.value!;

        print('🔥 Updating banner in Firestore...');
        await repository.updateBanner(item);

        BannerController.instance.updateItemFromLists(item);

        RSFullScreenLoader.stopLoading();
        RSLoaders.success(
          message: 'Banner updated successfully!',
        );

        reset();
        Get.offNamed(RSRoutes.banners);
      } catch (e, s) {
        RSFullScreenLoader.stopLoading();
        print('❌ Update banner failed: $e');
        print(s);
        RSLoaders.error(message: e.toString());
      }
    });
  }

  // ---------------------------------------------------------------------------
// CLEANUP / RESET
// ---------------------------------------------------------------------------
  void reset() {
    print('♻️ Resetting EditBannerController state');

    imageURL.value = '';
    isActive.value = false;
    targetScreen.value = '';
    bannerType.value = 'category';
    bannerValue.value = '';
    priority.value = 1;

    startDate.value = null;
    endDate.value = null;

    startDateController.clear();
    endDateController.clear();
    bannerValueController.clear();
    priorityController.clear();

    banner.value = null;
    _loaded = false;
  }

}