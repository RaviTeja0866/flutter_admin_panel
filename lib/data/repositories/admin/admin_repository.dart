import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../features/personalization/models/admin_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AdminRepository extends GetxController {
  static AdminRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'Adminusers';

  // =========================
  // 🌐 API CONFIG (CURRENT)
  // =========================
  static const String _apiBaseUrl = 'https://api.roguestore.in';

  static String get _createAdminUrl =>
      '$_apiBaseUrl/admin/create';

  // =========================
  // Fetch admin by UID
  // =========================
  Future<AdminUserModel?> fetchAdminByUid(String uid) async {
    try {
      final doc = await _db.collection(_collection).doc(uid).get();
      if (!doc.exists) return null;
      return AdminUserModel.fromSnapshot(doc);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // =========================
  // Create admin (API)
  // =========================
  Future<void> createAdminUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String roleId,
  }) async {
    try {
      // 🔐 Auth check
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      // 🔑 Force-refresh token (claims safe)
      final token = await user.getIdToken(true);
      if (token == null) {
        throw 'Failed to get auth token';
      }

      final payload = {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'roleId': roleId,
      };

      final res = await http.post(
        Uri.parse(_createAdminUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      switch (res.statusCode) {
        case 200:
          return;

        case 401:
          throw 'Session expired. Please login again.';

        case 403:
          throw 'You do not have permission to create admins.';

        default:
          throw 'Admin creation failed (${res.statusCode}): ${res.body}';
      }
    } catch (e) {
      _handleError(e);
    }
  }

  // =========================
  // Update admin
  // =========================
  Future<void> updateAdmin(AdminUserModel admin) async {
    try {
      await _db.collection(_collection).doc(admin.id).update(admin.toJson());
    } catch (e) {
      _handleError(e);
    }
  }

  // =========================
  // Toggle Active Status
  // =========================
  Future<void> toggleAdminStatus({
    required String uid,
    required bool isActive,
  }) async {
    try {
      await _db.collection(_collection).doc(uid).update({
        'isActive': isActive,
      });
    } catch (e) {
      _handleError(e);
    }
  }

  // =========================
  // Delete admin
  // =========================
  Future<void> deleteAdmin(String uid) async {
    try {
      await _db.collection(_collection).doc(uid).delete();
    } catch (e) {
      _handleError(e);
    }
  }

  // =========================
  // List all admins
  // =========================
  Future<List<AdminUserModel>> getAllAdmins() async {
    try {
      final snapshot = await _db.collection(_collection).get();
      return snapshot.docs
          .map((doc) => AdminUserModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      _handleError(e);
      return [];
    }
  }

  // =========================
  // Error Handler
  // =========================
  Never _handleError(dynamic e) {
    if (e is FirebaseException) {
      throw RSPlatformException(e.code).message;
    }
    if (e is FormatException) {
      throw const RSFormatException();
    }
    if (e is PlatformException) {
      throw RSPlatformException(e.code).message;
    }
    throw e.toString();
  }
}
