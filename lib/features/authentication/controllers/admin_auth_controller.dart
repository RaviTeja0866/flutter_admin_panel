import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/popups/loaders.dart';
import '../../personalization/models/admin_model.dart';
import '../../personalization/models/role_model.dart';

class AdminAuthController extends GetxController {
  static AdminAuthController get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final RxBool loading = false.obs;
  final RxBool isAdminReady = false.obs;

  final Rx<AdminUserModel?> admin = Rx<AdminUserModel?>(null);
  final Rx<RoleModel?> role = Rx<RoleModel?>(null);

  @override
  void onInit() {
    super.onInit();
    restoreSession();
  }

  Future<void> restoreSession() async {
    loading.value = true;
    isAdminReady.value = false;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        admin.value = null;
        role.value = null;
        return;
      }

      await _loadAdminAndRole(user.uid);
    } catch (e) {
      admin.value = null;
      role.value = null;
    } finally {
      loading.value = false;
      isAdminReady.value = true; // ✅ SAFE HERE
      debugPrint('🟢 [ADMIN] READY (restore) admin=${admin.value?.id}');
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    loading.value = true;
    isAdminReady.value = false;

    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _loadAdminAndRole(cred.user!.uid);

      // 🔑 ONLY set ready AFTER admin is set
      isAdminReady.value = true;
      debugPrint('🟢 [ADMIN] READY (login) admin=${admin.value?.id}');
    } finally {
      loading.value = false;
    }
  }

  Future<void> _loadAdminAndRole(String uid) async {
    debugPrint('🟡 [ADMIN] loading admin doc: $uid');

    try {
      final adminDoc = await _db
          .collection('Adminusers')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 5));

      debugPrint('🟢 [ADMIN] adminDoc received');
      debugPrint('🟢 [ADMIN] exists = ${adminDoc.exists}');
      debugPrint('🟢 [ADMIN] data = ${adminDoc.data()}');

      if (!adminDoc.exists) {
        throw Exception('Not an admin');
      }

      final adminUser = AdminUserModel.fromSnapshot(adminDoc);
      if (!adminUser.isActive) {
        throw Exception('Admin disabled');
      }

      final roleDoc = await _db
          .collection('Roles')
          .doc(adminUser.roleId)
          .get()
          .timeout(const Duration(seconds: 5));

      if (!roleDoc.exists) {
        throw Exception('Role missing');
      }

      admin.value = adminUser;
      role.value = RoleModel.fromSnapshot(roleDoc);

      debugPrint('🟢 [ADMIN] admin + role loaded');
    } catch (e) {
      debugPrint('❌ [ADMIN] Firestore error: $e');
      rethrow;
    }
  }


  bool get isLoggedIn => admin.value != null;

  Future<void> logout() async {
    await _auth.signOut();
    admin.value = null;
    role.value = null;
  }
}
