import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/edit_category_controller.dart';

import '../../../../../../common/widgets/images/image_uploader.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/validators/validation.dart';
import '../../../../controllers/category/category_controller.dart';
import '../../../../models/category_model.dart';

class EditCategoryForm extends StatelessWidget {
  const EditCategoryForm({super.key, required this.category});

  final CategoryModel category;


  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCategoryController());
    final categoryController = Get.put(CategoryController());
    return RSRoundedContainer(
      width: 500,
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Form(
        key: editController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              SizedBox(height: RSSizes.sm),
              Text('Update Category', style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Name Text Filed
              TextFormField(
                controller: editController.name,
                validator: (value) => RSValidator.validateEmptyText('Name', value),
                decoration: InputDecoration(labelText: 'CategoryName', prefixIcon: Icon(Iconsax.category)),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              Obx(
                ()=>  DropdownButtonFormField(
                  decoration: InputDecoration(hintText: 'ParentCategory', labelText: 'Parent Category', prefixIcon: Icon(Iconsax.bezier)),
                  value: editController.selectedParent.value.id.isNotEmpty ? editController.selectedParent.value : null,
                  onChanged: (newValue)  => editController.selectedParent.value = newValue!,
                  items: categoryController.allItems.map((item) =>
                      DropdownMenuItem(
                        value: item,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [Text(item.name)]),
                      )).toList(),
              ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields * 2),

              Obx(
                () => RSImageUploader(
                  width: 80,
                  height: 80,
                  image: editController.imageURL.value.isNotEmpty ? editController.imageURL.value : RSImages.defaultImage,
                  imageType: editController.imageURL.isNotEmpty ? ImageType.network :ImageType.asset ,
                  onIconButtonPressed: () => editController.pickImage(),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              Obx(
                () => CheckboxMenuButton(
                  value: editController.isFeatured.value,
                  onChanged: (value) => editController.isFeatured.value = value ?? false,
                  child: Text('Featured'),
                ),
              ),

              SizedBox(height: RSSizes.spaceBtwInputFields * 2),

              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => editController.updateCategory(), child: Text('Edit')),
                ),

              SizedBox(height: RSSizes.spaceBtwInputFields * 2),
            ],
          )),
    );
  }
}
