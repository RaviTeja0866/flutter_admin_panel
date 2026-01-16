import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/authentication/controllers/admin_auth_controller.dart';
import '../routes/routes.dart';

class RSRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final adminAuth = AdminAuthController.instance;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    debugPrint(
      '🛡️ route=$route '
          'firebase=${firebaseUser?.uid} '
          'adminReady=${adminAuth.isAdminReady.value} '
          'admin=${adminAuth.admin.value?.id}',
    );

    if (firebaseUser == null || !adminAuth.isAdminReady.value) {
      return null;
    }

    if (!adminAuth.isLoggedIn && route != RSRoutes.login) {
      return const RouteSettings(name: RSRoutes.login);
    }

    return null;
  }
}


