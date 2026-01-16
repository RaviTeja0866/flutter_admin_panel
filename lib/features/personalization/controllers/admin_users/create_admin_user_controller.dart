import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/admin/admin_repository.dart';
import '../../../../data/repositories/roles/role_repository.dart';
import '../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/admin_model.dart';
import '../../models/role_model.dart';

class CreateAdminUserController extends GetxController {
  static CreateAdminUserController get instance => Get.find();

  final _adminRepo = AdminRepository.instance;
  final _rolesRepo = RoleRepository.instance;

  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final RxString selectedRoleId = ''.obs;
  final RxList<RoleModel> roles = <RoleModel>[].obs;
  final RxBool isLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    roles.value = await _rolesRepo.getAllRoles();
  }

  Future<void> saveAdminUser() async {
    debugPrint('[CreateAdminUser] Save triggered');

    await ActionGuard.run(
      permission: Permission.adminCreate,
      showDeniedScreen: true,
      action: () async {
        if (!formKey.currentState!.validate()) {
          debugPrint('[CreateAdminUser] Form validation failed');
          return;
        }

        try {
          isLoading.value = true;

          debugPrint('[CreateAdminUser] Creating admin user');
          debugPrint('FullName: ${fullNameController.text}');
          debugPrint('Email: ${emailController.text}');
          debugPrint('Phone: ${phoneController.text}');
          debugPrint('RoleId: ${selectedRoleId.value}');

          await _adminRepo.createAdminUser(
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            roleId: selectedRoleId.value,
          );

          debugPrint('[CreateAdminUser] Admin user created successfully');

          Get.snackbar('Success', 'Admin user created. Invite sent.');
          clearForm();
        } catch (e, stack) {
          debugPrint('[CreateAdminUser] ERROR: $e');
          debugPrintStack(stackTrace: stack);
          Get.snackbar('Error', e.toString());
        } finally {
          isLoading.value = false;
          debugPrint('[CreateAdminUser] Loading stopped');
        }
      },
    );
  }

  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    selectedRoleId.value = '';
  }
}
