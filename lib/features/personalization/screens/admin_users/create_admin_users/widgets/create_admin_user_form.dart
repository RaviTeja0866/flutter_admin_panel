import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/admin_users/create_admin_user_controller.dart';
import '../../../../../../utils/constants/sizes.dart';

class CreateAdmminUserFormScreen extends StatelessWidget {
  CreateAdmminUserFormScreen({super.key});

  final controller = Get.put(CreateAdminUserController());

  @override
  Widget build(BuildContext context) {
    return RSRoundedContainer(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(RSSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ------------------------------------------------
              /// FULL NAME
              /// ------------------------------------------------
              TextFormField(
                controller: controller.fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter full name' : null,
              ),
              const SizedBox(height: RSSizes.spaceBtwInputFields),

              /// ------------------------------------------------
              /// EMAIL
              /// ------------------------------------------------
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter email address';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: RSSizes.spaceBtwInputFields),

              /// ------------------------------------------------
              /// PHONE NUMBER
              /// ------------------------------------------------
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: RSSizes.spaceBtwInputFields),

              /// ------------------------------------------------
              /// ROLE DROPDOWN
              /// ------------------------------------------------
              Obx(
                    () => DropdownButtonFormField<String>(
                  value: controller.selectedRoleId
                      .value.isEmpty
                      ? null
                      : controller.selectedRoleId
                      .value,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: controller.roles
                      .map(
                        (role) => DropdownMenuItem<String>(
                      value: role.id,
                      child: Text(role.name),
                    ),
                  )
                      .toList(),
                  onChanged: (value) =>
                  controller.selectedRoleId
                      .value = value ?? '',
                  validator: (value) =>
                  value == null ? 'Select a role' : null,
                ),
              ),

              const SizedBox(height: RSSizes.spaceBtwSections),

              /// ------------------------------------------------
              /// SAVE BUTTON
              /// ------------------------------------------------
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveAdminUser,
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Save Admin User'),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
