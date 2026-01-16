import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/personalization/models/role_model.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class RoleRepository extends GetxController {
  static RoleRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'Roles';

  // -------------------------
  // Fetch role by ID
  // -------------------------
  Future<RoleModel?> fetchRoleById(String roleId) async {
    try {
      final doc = await _db.collection(_collection).doc(roleId).get();
      if (!doc.exists) return null;
      return RoleModel.fromSnapshot(doc);
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // -------------------------
  // Create role
  // -------------------------
  Future<void> createRole(RoleModel role) async {
    try {
      await _db.collection(_collection).doc(role.id).set(role.toJson());
    } catch (e) {
      _handleError(e);
    }
  }

  // -------------------------
  // Update role (safe partial)
  // -------------------------
  Future<void> updateRole(RoleModel role) async {
    try {
      await _db.collection(_collection).doc(role.id).update(role.toJson());
    } catch (e) {
      _handleError(e);
    }
  }

  // -------------------------
  // Toggle Active Status
  // -------------------------
  Future<void> toggleRoleStatus({
    required String roleId,
    required bool isActive,
  }) async {
    try {
      await _db.collection(_collection).doc(roleId).update({
        'isActive': isActive,
      });
    } catch (e) {
      _handleError(e);
    }
  }

  // -------------------------
  // Delete role
  // -------------------------
  Future<void> deleteRole(String roleId) async {
    try {
      await _db.collection(_collection).doc(roleId).delete();
    } catch (e) {
      _handleError(e);
    }
  }

  // -------------------------
  // List all roles
  // -------------------------
  Future<List<RoleModel>> getAllRoles() async {
    try {
      final snapshot = await _db.collection(_collection).get();
      return snapshot.docs.map((doc) => RoleModel.fromSnapshot(doc)).toList();
    } catch (e) {
      _handleError(e);
      return [];
    }
  }

  // -------------------------
  // Error Handler
  // -------------------------
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
    throw 'Something went wrong. $e';
  }
}
