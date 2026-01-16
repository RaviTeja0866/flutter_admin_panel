import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/brand/edit_brand_controller.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';

import '../../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../models/brand_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../controllers/brand/edit_brand_controller.dart';

class EditBrandForm extends StatelessWidget {
  const EditBrandForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditBrandController.instance;

    return Obx(() {
      final brand = controller.brand.value;

      // ⛔ WAIT until brand is loaded (refresh-safe)
      if (brand == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return RSRoundedContainer(
        width: 500,
        padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Heading
              Text(
                'Edit Brand',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Brand Name
              TextFormField(
                controller: controller.name,
                validator: (value) =>
                    RSValidator.validateEmptyText('Brand Name', value),
                decoration: const InputDecoration(
                  labelText: 'Brand Name',
                  prefixIcon: Icon(Iconsax.box),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Categories
              Text(
                'Select Categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields / 2),

              Obx(
                    () => Wrap(
                  spacing: RSSizes.sm,
                  children: CategoryController.instance.allItems
                      .map(
                        (category) => Padding(
                      padding: EdgeInsets.only(bottom: RSSizes.sm),
                      child: RSChoiceChip(
                        text: category.name,
                        selected: controller.selectedCategories
                            .contains(category),
                        onSelected: (_) =>
                            controller.toggleSelection(category),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),

              SizedBox(height: RSSizes.spaceBtwInputFields * 2),

              // Image
              Obx(
                    () => RSImageUploader(
                  width: 80,
                  height: 80,
                  image: controller.imageURL.value.isNotEmpty
                      ? controller.imageURL.value
                      : RSImages.defaultImage,
                  imageType: controller.imageURL.value.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  onIconButtonPressed: controller.pickImage,
                ),
              ),

              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Featured
              Obx(
                    () => CheckboxMenuButton(
                  value: controller.isFeatured.value,
                  onChanged: (v) => controller.isFeatured.value = v ?? false,
                  child: const Text('Featured'),
                ),
              ),

              SizedBox(height: RSSizes.spaceBtwInputFields * 2),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.updateBrand,
                  child: const Text('Update Brand'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
