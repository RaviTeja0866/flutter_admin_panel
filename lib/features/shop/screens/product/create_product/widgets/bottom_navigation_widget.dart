import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/create_product_controller.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductBottomNavigationButtons extends StatelessWidget {
  const ProductBottomNavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return RSRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Discard Button
          OutlinedButton(onPressed: (){}, child: Text('Discard')),
          SizedBox(width: RSSizes.spaceBtwItems / 2),

          // Save Changes Button
          SizedBox(width: 160, child: ElevatedButton(onPressed: () => CreateProductController.instance.createProduct(), child: Text('Save Changes'))),
        ],
      ),
    );
  }
}
