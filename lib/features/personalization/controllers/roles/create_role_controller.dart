import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/popups/loaders.dart';
import '../../models/permission_group_model.dart';

class CreateRoleController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final roleNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final otherPermissionController = TextEditingController();

  final isPermissionDropdownOpen = false.obs;


  /// ----------------------------------------
  /// UI STATE
  /// ----------------------------------------

  final permissionGroups = <PermissionGroup>[].obs;

  /// which group is currently expanded (dropdown)
  final RxString expandedGroupKey = ''.obs;

  /// permission selection map: group.action -> bool
  final selectedPermissions = <String, bool>{}.obs;

  /// loader
  final isLoadingPermissions = true.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🟢 CreateRoleController initialized');
    fetchPermissionGroups();
  }

  /// ----------------------------------------
  /// FIRESTORE
  /// ----------------------------------------

  Future<void> fetchPermissionGroups() async {
    debugPrint('⏳ Fetching permission groups from Firestore...');
    try {
      isLoadingPermissions.value = true;

      final snapshot =
      await FirebaseFirestore.instance.collection('Permissions').get();

      permissionGroups.value = snapshot.docs
          .map((doc) => PermissionGroup.fromFirestore(doc.id, doc.data()))
          .toList();

      debugPrint('✅ Loaded ${permissionGroups.length} permission groups');
    } catch (e, stack) {
      debugPrint('❌ Failed to load permissions: $e');
      debugPrintStack(stackTrace: stack);

      Get.snackbar(
        'Error',
        'Failed to load permissions',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingPermissions.value = false;
    }
  }

  /// ----------------------------------------
  /// DROPDOWN (GROUP EXPAND / COLLAPSE)
  /// ----------------------------------------

  void toggleGroupExpand(String groupKey) {
    expandedGroupKey.value =
    expandedGroupKey.value == groupKey ? '' : groupKey;
  }

  bool isGroupExpanded(String groupKey) {
    return expandedGroupKey.value == groupKey;
  }

  void togglePermissionDropdown() {
    isPermissionDropdownOpen.toggle();
  }
  /// ----------------------------------------
  /// PERMISSION TOGGLES
  /// ----------------------------------------

  void togglePermission(String permission, bool value) {
    selectedPermissions[permission] = value;
    debugPrint(
      '🔐 Permission ${value ? "ENABLED" : "DISABLED"} → $permission',
    );
  }

  void toggleGroup(String groupKey, List<String> actions, bool value) {
    for (final action in actions) {
      final permissionKey = '$groupKey.$action';
      selectedPermissions[permissionKey] = value;
    }

    debugPrint(
      '🔐 Group ${value ? "ENABLED" : "DISABLED"} → $groupKey',
    );
  }

  /// ----------------------------------------
  /// GROUP STATE HELPERS (FOR CHECKBOX)
  /// ----------------------------------------

  bool isGroupChecked(String groupKey, List<String> actions) {
    return actions.every(
          (a) => selectedPermissions['$groupKey.$a'] == true,
    );
  }

  bool isGroupIndeterminate(String groupKey, List<String> actions) {
    final selectedCount = actions
        .where((a) => selectedPermissions['$groupKey.$a'] == true)
        .length;

    return selectedCount > 0 && selectedCount < actions.length;
  }

  /// ----------------------------------------
  /// HEADER SUMMARY (Permissions (Orders, Users))
  /// ----------------------------------------

  List<String> get selectedGroupLabels {
    return permissionGroups
        .where((g) => isGroupChecked(g.key, g.actions))
        .map((g) => g.label)
        .toList();
  }

  /// ----------------------------------------
  /// SAVE ROLE
  /// ----------------------------------------

  Future<void> saveRole() async {
    if (!formKey.currentState!.validate()) return;

    final permissions = selectedPermissions.entries
        .where((e) => e.value)
        .map((e) => _normalizePermission(e.key))
        .toList();

    await FirebaseFirestore.instance.collection('Roles').add({
      'name': roleNameController.text.trim(),
      'description': descriptionController.text.trim(),
      'permissions': permissions,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Get.back(result: true); // works ONLY if pushed with Get.to
  }

  String _normalizePermission(String raw) {
    // Roles.Create -> roleCreate
    final parts = raw.split('.');
    if (parts.length != 2) return '';

    final group = parts[0].toLowerCase();
    final action = parts[1].toLowerCase();

    // handle plural -> singular
    final normalizedGroup =
    group.endsWith('s') ? group.substring(0, group.length - 1) : group;

    // special cases
    if (normalizedGroup == 'order' && action == 'status') {
      return 'orderStatusUpdate';
    }

    if (normalizedGroup == 'exchange' && action == 'status') {
      return 'exchangeStatusUpdate';
    }

    if (normalizedGroup == 'return' && action == 'status') {
      return 'returnStatusUpdate';
    }

    return '$normalizedGroup${action[0].toUpperCase()}${action.substring(1)}';
  }

  @override
  void onClose() {
    roleNameController.dispose();
    descriptionController.dispose();
    otherPermissionController.dispose();
    super.onClose();
  }
}
