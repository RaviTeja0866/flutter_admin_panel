import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/banner/edit_banner_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';

import '../../../../../../common/widgets/appScreen/app_screen.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/rs_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class EditBannerForm extends StatelessWidget {
  const EditBannerForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditBannerController.instance;
    return RSRoundedContainer(
      width: 500,
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Form(
        key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              SizedBox(height: RSSizes.sm),
              Text('Update Banner', style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Image Uploader & Featured Checkbox
              Column(
                children: [
                  Obx(
                    ()=> RSRoundedImage(
                      width: 400,
                      height: 200,
                      backgroundColor: RSColors.primaryBackground,
                      image: controller.imageURL.value.isNotEmpty ? controller.imageURL.value : RSImages.defaultImage,
                      imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                    ),
                  ),
                  SizedBox(height: RSSizes.spaceBtwItems),
                  TextButton(onPressed: () => controller.pickImage(), child: Text('Select Image')),
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),
              // Banner Type Dropdown
              DropdownButtonFormField<String>(
                value: controller.bannerType.value,
                items: ['category', 'offer']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.capitalizeFirst!),
                ))
                    .toList(),
                onChanged: (value) => controller.bannerType.value = value!,
                decoration: InputDecoration(labelText: 'Banner Type'),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Banner Value Input
              TextFormField(
                controller: controller.bannerValueController,
                onChanged: (value) => controller.bannerValue.value = value,
                decoration: InputDecoration(labelText: 'Banner Value'),
                validator: (value) => value!.isEmpty ? 'Field required' : null,
              ),

              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Priority Input
              TextFormField(
                controller: controller.priorityController, // Set controller
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.priority.value = int.tryParse(value) ?? 1,
                decoration: InputDecoration(labelText: 'Priority'),
              ),

              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Start Date Picker
              TextFormField(
                controller: controller.startDateController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Start Date'),
                onTap: () => controller.selectStartDate(context),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // End Date Picker
              TextFormField(
                controller: controller.endDateController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'End Date'),
                onTap: () => controller.selectExpiryDate(context),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              Text('Make Your Banner Active or Inactive', style: Theme.of(context).textTheme.bodyMedium),
              Obx(()=> CheckboxMenuButton(value: controller.isActive.value, onChanged: (value) => controller.isActive.value = value ?? false,
              child: Text('Active'))),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // DropDown menu Screens
          Obx(
            () { return DropdownButton<String>(
              value: controller.targetScreen.value,
              onChanged: (String? newValue) => controller.targetScreen.value = newValue!,
              items: AppScreens.allAppScreensItems.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
            );},
          ),
              SizedBox(height: RSSizes.spaceBtwInputFields * 2),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => controller.updateBanner(), child: Text('Update')),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields * 2),
            ],
          )),
    );
  }
}
