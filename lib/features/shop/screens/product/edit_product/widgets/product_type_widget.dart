import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductTypeWidget extends StatelessWidget {
  const ProductTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;

    return Obx(
          () => Row(
        children: [
          Text('Product Type', style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(width: RSSizes.spaceBtwItems),
          // Radio button for single Product Type
          RadioMenuButton(
            value: ProductType.single,
            groupValue: controller.productType.value,
            onChanged: (value) {
              controller.productType.value = value ?? ProductType.single;
            },
            child: Text('Single'),
          ),
          // Radio button for Variable Product Type
          RadioMenuButton(
            value: ProductType.variable,
            groupValue: controller.productType.value,
            onChanged: (value) {
              controller.productType.value = value ?? ProductType.variable;
            },
            child: Text('Variable'),
          ),
        ],
      ),
    );
  }
}
