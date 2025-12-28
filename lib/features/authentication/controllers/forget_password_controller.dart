import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';


class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      RSFullScreenLoader.openLoadingDialog('Processing your Request', RSImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Manually check if email is verified
      //await checkEmailVerificationStatus();

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResentEmail(email.text.trim());

      // Remove Loader
      RSFullScreenLoader.stopLoading();

      // Show Success Screen
      RSLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link sent to reset password'.tr);

      // Redirect to Reset Password Screen
      //Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      RSFullScreenLoader.stopLoading();
    }
  }

  /// Resend Password Reset Email
  reSendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      RSFullScreenLoader.openLoadingDialog('Processing your Request', RSImages.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResentEmail(email);

      // Remove Loader
      RSFullScreenLoader.stopLoading();

      // Show Success Screen
      RSLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link sent to reset password'.tr);
    } catch (e) {
      // Remove Loader
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
