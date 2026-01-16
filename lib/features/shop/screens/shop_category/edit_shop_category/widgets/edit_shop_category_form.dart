import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/shop_category/edit_shop_category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/shop_category.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

class EditShopCategoryForm extends StatelessWidget {
  const EditShopCategoryForm({super.key, required this.shopCategory});

  final ShopCategory shopCategory;

  @override
  Widget build(BuildContext context) {
    final controller = EditShopCategoryController.instance;
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
            Text('Edit Shop Category', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: RSSizes.spaceBtwSections),

            // Image Uploader
            Column(
              children: [
                Obx(
                      () => GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: RSRoundedImage(
                      width: 400,
                      height: 200,
                      backgroundColor: RSColors.primaryBackground,
                      image: controller.imageURL.value.isNotEmpty
                          ? controller.imageURL.value
                          : RSImages.defaultImage,
                      imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                    ),
                  ),
                ),
                SizedBox(height: RSSizes.spaceBtwItems),
                TextButton(onPressed: () => controller.pickImage(), child: Text('Select Image')),
              ],
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Category Title
            TextFormField(
              controller: controller.titleController,
              decoration: InputDecoration(labelText: 'Category Title'),
              validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Category Type
            TextFormField(
              controller: controller.typeController,
              decoration: InputDecoration(labelText: 'Category Type'),
              validator: (value) => value!.isEmpty ? 'Please enter a category type' : null,
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Gender
            Obx(
                  () => DropdownButton<String>(
                value: controller.gender.value,
                onChanged: (String? newValue) => controller.gender.value = newValue!,
                items: ['Men', 'Women', 'Kids', 'Unisex'].map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Active Checkbox
            Text('Make Your Category Active or Inactive', style: Theme.of(context).textTheme.bodyMedium),
            Obx(
                  () => CheckboxListTile(
                value: controller.isActive.value,
                onChanged: (value) => controller.isActive.value = value ?? false,
                title: Text('Active'),
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields * 2),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateShopCategory(),
                child: Text('Update'),
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
