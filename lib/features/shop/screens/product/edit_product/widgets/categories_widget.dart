import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';
import 'package:roguestore_admin_panel/utils/helpers/cloud_helper_functions.dart';

import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/product_model.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          Text('Category', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Single category selection using DropdownButton
          FutureBuilder<CategoryModel>(
            future: productController.loadSelectedCategory(product.id),
            builder: (context, snapshot) {
              final widget = RSCloudHelperFunctions.checkSingleRecordState(snapshot);
              if (widget != null) return widget;

              return Obx(() {
                // Ensure only one category can be selected
                return DropdownButtonFormField<CategoryModel>(
                  value: productController.selectedCategory.value,
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    border: OutlineInputBorder(),
                  ),
                  items: CategoryController.instance.allItems
                      .map((category) => DropdownMenuItem<CategoryModel>(
                    value: category,
                    child: Text(category.name),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      productController.selectedCategory.value = value; // Set selected category
                    }
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
