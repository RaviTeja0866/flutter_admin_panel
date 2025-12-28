import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/create_category_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';

import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';

class CreateCategoryForm extends StatelessWidget {
  const CreateCategoryForm({super.key});
  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCategoryController());
    final categoryController = Get.put(CategoryController());
    return RSRoundedContainer(
      width: 500,
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          SizedBox(height: RSSizes.sm),
          Text('Create New Category', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: RSSizes.spaceBtwSections),

          // Name Text Filed
          TextFormField(
            controller: createController.name,
            validator: (value) => RSValidator.validateEmptyText('Name', value),
            decoration: InputDecoration(
                labelText: 'CategoryName', prefixIcon: Icon(Iconsax.category)),
          ),
          SizedBox(height: RSSizes.spaceBtwInputFields),

           // Categories DropDown

          Obx(
            ()=> categoryController.isLoading.value ?
             RSShimmerEffect(width: double.infinity, height: 55)
            : DropdownButtonFormField(
              decoration: InputDecoration(
                hintText: 'ParentCategory',
                labelText: 'Parent Category',
                prefixIcon: Icon(Iconsax.bezier),
              ),
              onChanged: (newValue) {},
              items: categoryController.allItems.map((item) => DropdownMenuItem(
                value: item,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Text(item.name)],
                ),
              )).toList(),
            ),
          ),

          SizedBox(height: RSSizes.spaceBtwInputFields * 2),

          Obx(
            () => RSImageUploader(
              width: 80,
              height: 80,
              image: createController.imageURL.value.isNotEmpty? createController.imageURL.value : RSImages.defaultImage,
              imageType: createController.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
              onIconButtonPressed: () => createController.pickImage(),
            ),
          ),
          SizedBox(height: RSSizes.spaceBtwInputFields),

          Obx(
            ()=>  CheckboxMenuButton(
              value: createController.isFeatured.value,
              onChanged: (value) => createController.isFeatured.value = value ?? false,
              child: Text('Featured'),
            ),
          ),

          SizedBox(height: RSSizes.spaceBtwInputFields * 2),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () => createController.createCategory(), child: Text('Create')),
          ),

          SizedBox(height: RSSizes.spaceBtwInputFields * 2),
        ],
      )),
    );
  }
}
