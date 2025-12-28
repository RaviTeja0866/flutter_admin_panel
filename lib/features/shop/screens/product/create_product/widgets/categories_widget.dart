import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/create_product_controller.dart';
import '../../../../models/category_model.dart';

class ProductCategories extends StatelessWidget {
  const ProductCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    // Fetch categories if the list is empty
    if (categoryController.allItems.isEmpty) {
      categoryController.fetchItems();
    }

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories label
          Text('Category', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Dropdown for selecting a single category
          Obx(
                () => categoryController.isLoading.value
                ? RSShimmerEffect(width: double.infinity, height: 50)
                : DropdownButtonFormField<CategoryModel>(
              value: CreateProductController.instance.selectedCategory.value,
              decoration: InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(),
              ),
              items: categoryController.allItems
                  .map((category) => DropdownMenuItem<CategoryModel>(
                value: category, // Store full CategoryModel
                child: Text(category.name),
              ))
                  .toList(),
              onChanged: (CategoryModel? value) {
                if (value != null) {
                  CreateProductController.instance.selectedCategory.value = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
