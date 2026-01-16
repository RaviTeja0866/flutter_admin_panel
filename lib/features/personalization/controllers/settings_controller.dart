import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:roguestore_admin_panel/features/personalization/models/settings_model.dart';
import 'package:roguestore_admin_panel/utils/helpers/network_manager.dart';
import 'package:roguestore_admin_panel/utils/popups/full_screen_loader.dart';

import '../../../data/repositories/settings/settings_repository.dart';
import '../../../utils/popups/loaders.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  //Observable variables
 RxBool loading = false.obs;
 Rx<SettingsModel> settings = SettingsModel().obs;

 final formKey = GlobalKey<FormState>();
 final appNameController = TextEditingController();
  final taxController = TextEditingController();
  final shippingController = TextEditingController();
  final freeShippingController = TextEditingController();

  // Dependencies
  final settingsRepository = Get.put(SettingsRepository());

  @override
  void onInit() {
    fetchSettingDetails();
    super.onInit();
  }


  // Function setting details fro the repository
  Future<SettingsModel> fetchSettingDetails() async{
    try{
      loading.value = true;
      final settings = await settingsRepository.getSettings();
      this.settings.value = settings;

      appNameController.text = settings.appName;
      taxController.text = settings.taxRate.toString();
      shippingController.text = settings.shippingCost.toString();
      freeShippingController.text = settings.freeShippingThreshold == null ? '' : settings.freeShippingThreshold.toString();

      loading.value = false;
      return settings;
    } catch(e){
      RSLoaders.error(message: e.toString());
      return SettingsModel();
    }
  }

  //pick Thumbnail image from media
  void updateAppLogo() async{
    try{
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages =  await controller.selectImagesFromMedia();

      if(selectedImages != null && selectedImages.isNotEmpty){
        ImageModel selectedImage = selectedImages.first;

        await settingsRepository.updateSingleField({'appLogo' : selectedImage.url});

        settings.value.appLogo = selectedImage.url;
        settings.refresh();
        
        RSLoaders.success(message: 'App Logo Has Been updated.');
      }
      loading.value = false;
    } catch(e){
      loading.value = false;
      RSLoaders.error(message: e.toString());
    }
  }

  void updateSettingInformation() async{
    try{
      loading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        RSFullScreenLoader.stopLoading();
        return;
      }

      //Form Validation
      if(!formKey.currentState!.validate()){
        RSFullScreenLoader.stopLoading();
        return;
      }

      settings.value.appName = appNameController.text.trim();
      settings.value.taxRate = double.tryParse(taxController.text.trim()) ?? 0.0;
      settings.value.shippingCost = double.tryParse(shippingController.text.trim()) ?? 0.0;
      settings.value.freeShippingThreshold = double.tryParse(freeShippingController.text.trim()) ?? 0.0;

      await settingsRepository.updateSettingDetails(settings.value);
      settings.refresh();

      loading.value = false;
      RSLoaders.success(message: 'App Settings Has Been updated.');
    } catch(e){
      loading.value = false;
      RSLoaders.error(message: e.toString());
    }
  }
}