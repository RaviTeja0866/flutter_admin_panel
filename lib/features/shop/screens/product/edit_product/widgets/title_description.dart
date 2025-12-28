import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductTitleAndDescription extends StatelessWidget {
  const ProductTitleAndDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());

    return RSRoundedContainer(
      child: Form(
        key: controller.titleDescriptionFormKey,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic information Text
          Text('Basic Information',style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Product title Input field
          TextFormField(
            controller: controller.title,
            validator: (value) => RSValidator.validateEmptyText('Product Title', value),
            decoration: InputDecoration(labelText: 'Product Title'),
          ),
          SizedBox(height: RSSizes.spaceBtwInputFields),

          // Product Description Input field
          SizedBox(
            height: 300,
            child: TextFormField(
              expands: true,
              maxLines: null,
              textAlign: TextAlign.start,
              controller: controller.description,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              validator:  (value) => RSValidator.validateEmptyText('Product Description', value),
              decoration: InputDecoration(
                labelText: 'Product Description',
                hintText: 'Add your Product Description here...',
                alignLabelWithHint: true,
              ),
            ),
          )

        ],
      )),
    );
  }
}
