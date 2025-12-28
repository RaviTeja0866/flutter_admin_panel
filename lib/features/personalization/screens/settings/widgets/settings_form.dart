import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/settings_controller.dart';

import '../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Column(
      children: [
        RSRoundedContainer(
          padding: EdgeInsets.symmetric(vertical: RSSizes.lg, horizontal: RSSizes.md),
          child: Form(
            key: controller.formKey,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings',style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: RSSizes.spaceBtwSections),

              // App name
              TextFormField(
                controller: controller.appNameController,
                decoration: InputDecoration(
                  hintText: 'App Name',
                  label: Text('App Name'),
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Email And Phone
              Row(
                children: [
                  // Email
                  Expanded(child: TextFormField(
                    controller: controller.taxController,
                    decoration: InputDecoration(
                      hintText: 'Tax %',
                      label: Text('Tax Rate (%)'),
                      prefixIcon: Icon(Iconsax.tag),
                    ),
                  )),
                  SizedBox(width: RSSizes.spaceBtwItems),

                  Expanded(child: TextFormField(
                    controller: controller.shippingController,
                    decoration: InputDecoration(
                      hintText: 'Shipping cost',
                      label: Text('shipping cost (₹)'),
                      prefixIcon: Icon(Iconsax.ship),
                    ),
                  )),
                  SizedBox(width: RSSizes.spaceBtwItems),

                  Expanded(child: TextFormField(
                    controller: controller.freeShippingController,
                    decoration: InputDecoration(
                      hintText: 'Free Shipping After(₹)',
                      label: Text('Free Shipping Threshold (₹)'),
                      prefixIcon: Icon(Iconsax.ship),
                    ),
                  )),
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields * 2),

              SizedBox(
                width: double.infinity,
                child: Obx(
                  ()=> ElevatedButton(
                      onPressed: () => controller.loading.value ? () {} : controller.updateSettingInformation(),
                      child: controller.loading.value
                  ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : Text('Update App Settings'),
                  ),
                ),
              ),
            ],
          ),),
        )
      ],
    );
  }
}
