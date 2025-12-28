import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/user_controller.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';

import '../../../../../utils/constants/sizes.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserProfileController.instance;
    controller.firstNameController.text = controller.user.value.firstName;
    controller.lastNameController.text = controller.user.value.lastName;
    controller.phoneController.text = controller.user.value.phoneNumber;

    return Column(
      children: [
        RSRoundedContainer(
          padding: EdgeInsets.symmetric(vertical: RSSizes.lg, horizontal: RSSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile Details',style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: RSSizes.spaceBtwSections),

              // First and Last name
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // First Name
                        Expanded(child: TextFormField(
                          controller: controller.firstNameController,
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            label: Text('First Name'),
                            prefixIcon: Icon(Iconsax.user),
                          ),
                          validator: (value) => RSValidator.validateEmptyText('First Name', value),
                        )),
                        SizedBox(height: RSSizes.spaceBtwInputFields),
                        // Last Name
                        Expanded(child: TextFormField(
                          controller: controller.lastNameController,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            label: Text('Last Name'),
                            prefixIcon: Icon(Iconsax.user),
                          ),
                          validator: (value) => RSValidator.validateEmptyText('Last Name', value),
                        )),
                      ],
                    ),
                    SizedBox(height: RSSizes.spaceBtwInputFields),

                    // Email And Phone
                    Row(
                      children: [
                        // Email
                        Expanded(child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            label: Text('Email'),
                            prefixIcon: Icon(Iconsax.forward),
                            enabled: false,
                          ),
                          initialValue: UserProfileController.instance.user.value.email,
                        )),
                        SizedBox(height: RSSizes.spaceBtwItems),
                        Expanded(child: TextFormField(
                          controller: controller.phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            label: Text('Phone Number'),
                            prefixIcon: Icon(Iconsax.mobile),
                            enabled: false,
                          ),
                          validator: (value) => RSValidator.validateEmptyText('Phone Number', value),
                        )),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: Obx(
                      ()=> ElevatedButton(
                    onPressed: () => controller.loading.value ? () {} : controller.updateUserInformation(),
                    child: controller.loading.value
                        ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : Text('Update Profile'),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
