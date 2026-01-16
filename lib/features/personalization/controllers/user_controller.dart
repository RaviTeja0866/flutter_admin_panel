import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:roguestore_admin_panel/utils/helpers/network_manager.dart';
import 'package:roguestore_admin_panel/utils/popups/full_screen_loader.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../../shop/models/user_model.dart';
import '../models/admin_model.dart';

class UserProfileController extends GetxController {
  static UserProfileController get instance => Get.find();

  //Observable variables
  RxBool loading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  // Dependencies
  final userRepository = UserRepository.instance;

  @override
  void onInit() {
    super.onInit();
  }


  //pick Thumbnail image from media
  void updateProfilePicture() async{
    try{
      loading.value = true;
      final controller = Get.put(MediaController());
      List<ImageModel>? selectedImages =  await controller.selectImagesFromMedia();

      if(selectedImages != null && selectedImages.isNotEmpty){
        ImageModel selectedImage = selectedImages.first;

        await userRepository.updateSingleFiled({'ProfilePicture' : selectedImage.url});

        user.value.profilePicture = selectedImage.url;
        user.refresh();

        RSLoaders.success(message: 'Your Profile Picture Has Been updated.');
      }
      loading.value = false;
    } catch(e){
      loading.value = false;
      RSLoaders.error(message: e.toString());
    }
  }

  void updateUserInformation() async{
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

      user.value.firstName = firstNameController.text.trim();
      user.value.lastName = lastNameController.text.trim();
      user.value.phoneNumber = phoneController.text.trim();


      await userRepository.updateUserDetails(user.value);
      user.refresh();

      loading.value = false;
      RSLoaders.success(message: 'Your Profile Has Been updated.');
    } catch(e){
      loading.value = false;
      RSLoaders.error(message: e.toString());
    }
  }
}