import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/edit_product_controller.dart';
import '../../../../models/product_model.dart';

class IsFeaturedWidget extends StatelessWidget {
  const IsFeaturedWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = EditProductController.instance;
    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Is Featured label
          Text('Is Featured', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          Obx(
                ()=>  CheckboxMenuButton(
              value: controller.isFeatured.value,
              onChanged: (value) => controller.isFeatured.value = value ?? false,
              child: Text('Featured'),
            ),
          ),
        ],
      ),
    );
  }
}
