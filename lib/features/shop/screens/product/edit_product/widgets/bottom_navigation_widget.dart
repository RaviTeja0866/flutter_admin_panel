import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/product_model.dart';

class ProductBottomNavigationButtons extends StatelessWidget {
  const ProductBottomNavigationButtons({super.key, required this.product});

  final ProductModel product;

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
          SizedBox(width: 160, child: ElevatedButton(onPressed: () => EditProductController.instance.updateProduct(product), child: Text('Save Changes'))),
        ],
      ),
    );
  }
}
