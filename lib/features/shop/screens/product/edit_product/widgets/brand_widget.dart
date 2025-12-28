import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/brand/brand_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';

import '../../../../../../utils/constants/sizes.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProductController());
    final brandController = Get.put(BrandController());

    // Initialize TextEditingController with the brand name
    final TextEditingController brandTextController = TextEditingController(
      text: controller.selectedBrand.value?.name ?? '', // Set initial value
    );

    // Fetch Brands if list is Empty
    if(brandController.allItems.isEmpty){
      brandController.fetchItems();
    }
    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Label
          Text('Brand', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          //TypeAheadField for brand election
          Obx(
              () => brandController.isLoading.value
              ? RSShimmerEffect(width: double.infinity, height: 50)
              : TypeAheadField(
              builder: (context, ctr, focusNode){
                return TextFormField(
                  focusNode: focusNode,
                  controller: brandTextController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Select Brand',
                    suffixIcon: Icon(Iconsax.box),
                  ),
                );
              },
                suggestionsCallback: (pattern){
                // Return filtered brand suggestion on the search pattern
                  return brandController.allItems.where((brand) => brand.name.contains(pattern)).toList();
                },
                itemBuilder: (context, suggestion){
                return ListTile(title: Text(suggestion.name));
                },
                onSelected: (suggestion){
                controller.selectedBrand.value = suggestion;
                controller.brandTextField.text = suggestion.name;
                },
                ),
          )
        ],
      ),
    );
  }
}
