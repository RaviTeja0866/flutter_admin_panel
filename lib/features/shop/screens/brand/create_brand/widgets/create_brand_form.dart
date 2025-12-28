import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';

import '../../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/brand/create_brand_controller.dart';

class CreateBrandForm extends StatelessWidget {
  const CreateBrandForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateBrandController());
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
          Text('Create New Brand', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),

          // Name Text Filed
          TextFormField(
            controller: controller.name,
            validator: (value) => RSValidator.validateEmptyText('Name', value),
            decoration: InputDecoration(labelText: 'Brand Name', prefixIcon: Icon(Iconsax.box)),
          ),
          SizedBox(height: RSSizes.spaceBtwInputFields),

          // categories
          Text('Select Categories', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: RSSizes.spaceBtwInputFields / 2),
          Obx(()=> Wrap(
              spacing: RSSizes.sm,
              children: CategoryController.instance.allItems.map((category) => Padding(
                padding: EdgeInsets.only(bottom: RSSizes.sm),
                child: RSChoiceChip(text: category.name,
                    selected: controller.selectedCategories.contains(category),
                    onSelected: (value) => controller.toggleSelection(category)),
              )).toList(),
            ),
          ),
          SizedBox(height: RSSizes.spaceBtwInputFields * 2),

          // Image Uploader & Featured Checkbox
          Obx(
            ()=> RSImageUploader(
              width: 80,
              height: 80,
              image: controller.imageURL.value.isNotEmpty ? controller.imageURL.value : RSImages.defaultImage,
              imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
              onIconButtonPressed: () => controller.pickImage(),
            ),
          ),
          SizedBox(height: RSSizes.spaceBtwInputFields),

          Obx(
            () => CheckboxMenuButton(
              value: controller.isFeatured.value,
              onChanged: (value) => controller.isFeatured.value = value ?? false,
              child: Text('Featured'),
            ),
          ),

          SizedBox(height: RSSizes.spaceBtwInputFields * 2),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () => controller.createBrand(), child: Text('Create')),
          ),

          SizedBox(height: RSSizes.spaceBtwInputFields * 2),
        ],
      )),
    );
  }
}
