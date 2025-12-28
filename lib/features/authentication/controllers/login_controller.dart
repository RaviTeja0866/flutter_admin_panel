  import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
  import 'package:roguestore_admin_panel/data/repositories/authentication/authentication_repository.dart';
  import 'package:roguestore_admin_panel/data/repositories/settings/settings_repository.dart';
  import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
  import 'package:roguestore_admin_panel/features/personalization/controllers/user_controller.dart';
  import 'package:roguestore_admin_panel/features/personalization/models/settings_model.dart';
  import 'package:roguestore_admin_panel/features/personalization/models/user_model.dart';
  import 'package:roguestore_admin_panel/utils/constants/enums.dart';
  import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
  import 'package:roguestore_admin_panel/utils/constants/text_strings.dart';
  import 'package:roguestore_admin_panel/utils/helpers/network_manager.dart';
  import 'package:roguestore_admin_panel/utils/popups/full_screen_loader.dart';
  import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

  // Controller for handling login functionality
  class LoginController extends GetxController {
    static LoginController get instance => Get.find();

    final hidePassword = true.obs;
    final rememberMe = false.obs;
    final localStorage = GetStorage();

    final email = TextEditingController();
    final password = TextEditingController();
    final loginFormKey = GlobalKey<FormState>();

    @override
    void onInit() {
      email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
      password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
      super.onInit();
    }

    // Handles email and password sign-in process
    Future<void> emailAndPasswordSignIn() async {
      try {
        // Start Loader
        RSFullScreenLoader.openLoadingDialog(
          'Logging in Admin Account',
          RSImages.docerAnimation,
        );

        // Check Internet
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          RSFullScreenLoader.stopLoading();
          RSLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection.',
          );
          return;
        }

        // Form Validation
        if (!loginFormKey.currentState!.validate()) {
          RSFullScreenLoader.stopLoading();
          return;
        }

        // Remember Me
        if (rememberMe.value) {
          localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
          localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
        }

        // LOGIN WITH EMAIL + PASSWORD
        await AuthenticationRepository.instance.loginWithEmailAndPassword(
          email.text.trim(),
          password.text.trim(),
        );

        // -------------------------------
        // TEMPORARY OPTION-B: AUTO ADMIN
        // -------------------------------
        final uid = FirebaseAuth.instance.currentUser!.uid;

        final response = await http.post(
          Uri.parse("https://bmfnlmu22h.execute-api.ap-south-1.amazonaws.com/prod/adminRole"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"uid": uid}),
        );

        print("[MAKE ADMIN RESPONSE] ${response.body}");

        // Force refresh ID token so role claim loads
        await FirebaseAuth.instance.currentUser!.getIdToken(true);

        // Fetch user profile
        final user = await UserProfileController.instance.fetchUserDetails();

        // Stop loader
        RSFullScreenLoader.stopLoading();

        // -------------------------------
        // VERIFY ROLE USING CUSTOM CLAIM
        // -------------------------------
        final idToken = await FirebaseAuth.instance.currentUser!.getIdTokenResult();
        final role = idToken.claims?["role"];

        print("[CUSTOM CLAIM ROLE] $role");

        if (role != "admin") {
          await AuthenticationRepository.instance.logout();
          RSLoaders.errorSnackBar(
            title: 'Not Authorized',
            message: 'Admin privileges not granted.',
          );
          return;
        }

        // SUCCESS → Redirect to dashboard
        AuthenticationRepository.instance.screenRedirect();
      } catch (e) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(
          title: 'Oh Snap',
          message: e.toString(),
        );
      }
    }

    // Handles registration of admin user
    Future<void> registerAdmin() async {
      try {

        // Start Loading
        RSFullScreenLoader.openLoadingDialog('Registering Admin Account', RSImages.docerAnimation);

        // Check Internet Connectivity
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          RSFullScreenLoader.stopLoading();
          RSLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
          return;
        }

        // Register user using email and password authentication
        await AuthenticationRepository.instance.registerWithEmailAndPassword(RSTexts.adminEmail, RSTexts.adminPassword);

        // Create Admin record in the Firestore
        final userRepository = Get.put(UserRepository());
        final adminUser = UserModel(
          id: AuthenticationRepository.instance.authUser!.uid,
          firstName: 'Roguestore',
          lastName: 'Admin',
          email: RSTexts.adminEmail,
          role: AppRole.admin,
          createdAt: DateTime.now(),
        );

        final settingsRepository = Get.put(SettingsRepository());
        await settingsRepository.registerSettings(SettingsModel(appLogo: '', appName: 'Roguestore', taxRate: 0, shippingCost: 0));

        await userRepository.createUser(adminUser);

        // Remove Loader
        RSFullScreenLoader.stopLoading();

        // Redirect
        AuthenticationRepository.instance.screenRedirect();
      } catch (e) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
      }
    }
  }
