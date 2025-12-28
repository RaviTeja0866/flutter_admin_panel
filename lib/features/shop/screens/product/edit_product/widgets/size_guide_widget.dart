import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/size_guide/size_guide_controller.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/edit_product_controller.dart';
import '../../../../models/size_guide_model.dart';

class RSProductSizeGuide extends StatelessWidget {
  const RSProductSizeGuide({super.key, required this.sizeGuide});

  final String? sizeGuide;

  @override
  Widget build(BuildContext context) {
    final sizeGuideController = Get.put(SizeGuideController());
    final productController = EditProductController.instance;

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Size Guide', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Reactive Dropdown
          Obx(() {
            // Ensure selectedSizeGuide is set correctly
            final selectedValue = productController.selectedSizeGuide.value;

            return DropdownButtonFormField<SizeGuideModel>(
              value: selectedValue, // Correctly bind the selected value
              decoration: InputDecoration(
                labelText: 'Garment Type',
                border: OutlineInputBorder(),
              ),
              items: sizeGuideController.allItems.map((sizeGuide) {
                return DropdownMenuItem<SizeGuideModel>(
                  value: sizeGuide,
                  child: Text(sizeGuide.garmentType),
                );
              }).toList(),
              onChanged: (SizeGuideModel? value) {
                if (value != null) {
                  productController.selectedSizeGuide.value = value;
                }
              },
            );
          }),
        ],
      ),
    );
  }
}


