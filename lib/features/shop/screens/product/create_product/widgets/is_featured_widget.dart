import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/create_product_controller.dart';

import '../../../../../../utils/constants/sizes.dart';

class IsFeaturedWidget extends StatelessWidget {
  const IsFeaturedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CreateProductController.instance;
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
