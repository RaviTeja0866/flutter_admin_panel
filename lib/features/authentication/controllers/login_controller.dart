import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../routes/routes.dart';
import '../../authentication/controllers/admin_auth_controller.dart';

/// ============================================================
/// ⚠️ DEV ONLY FLAG
/// SET TO false BEFORE PRODUCTION
/// ============================================================
const bool DEV_AUTO_ADMIN = true;

/// Replace with your actual Lambda URL
const String MAKE_ADMIN_LAMBDA_URL =
    'https://bmfnlmu22h.execute-api.ap-south-1.amazonaws.com/prod/adminRole'; // <-- UPDATE THIS

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
    super.onInit();
    email.text = localStorage.read('ADMIN_EMAIL') ?? '';
    debugPrint('🟢 [LOGIN] Controller initialized');
  }

  // ------------------------------------------------
  // LOGIN
  // ------------------------------------------------
  Future<void> login() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      throw Exception('Please check your internet connection.');
    }

    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    if (rememberMe.value) {
      localStorage.write('ADMIN_EMAIL', email.text.trim());
    } else {
      localStorage.remove('ADMIN_EMAIL');
    }

    final adminController = AdminAuthController.instance;
    await adminController.login(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    if (DEV_AUTO_ADMIN) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not found');

      final idToken = await user.getIdToken(true);
      if (idToken == null) throw Exception('Failed to retrieve ID token');

      await _makeAdmin(uid: user.uid, idToken: idToken);
      await user.getIdToken(true);
    }
  }

  // ------------------------------------------------
  // DEV HELPER: CALL MAKE-ADMIN LAMBDA
  // ------------------------------------------------
  Future<void> _makeAdmin({
    required String uid,
    required String idToken,
  }) async {
    final response = await http.post(
      Uri.parse(MAKE_ADMIN_LAMBDA_URL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({'uid': uid}),
    );

    if (response.statusCode != 200) {
      debugPrint('❌ [DEV] Make admin failed: ${response.body}');
      throw 'Failed to assign admin role';
    }
  }

  // ------------------------------------------------
  // ERROR HANDLER
  // ------------------------------------------------
  void _stopWithError(String message) {
    RSFullScreenLoader.stopLoading();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RSLoaders.error(message: message);
    });
  }
}
