import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/size_guide/size_guide_controller.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/create_product_controller.dart';
import '../../../../models/size_guide_model.dart';

class RSProductSizeGuide extends StatelessWidget {
  const RSProductSizeGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeGuideController = Get.put(SizeGuideController());

    // Fetch size guides if the list is empty
    if (sizeGuideController.allItems.isEmpty) {
      sizeGuideController.fetchItems();
    }

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Size Guide label
          Text('Size Guide', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Dropdown for selecting a size guide
          Obx(
                () => sizeGuideController.isLoading.value
                ? RSShimmerEffect(width: double.infinity, height: 50)
                : DropdownButtonFormField<SizeGuideModel>(
              value: CreateProductController.instance.selectedSizeGuide.value,
              decoration: InputDecoration(
                labelText: 'Select Garment Type',
                border: OutlineInputBorder(),
              ),
              items: sizeGuideController.allItems
                  .map((sizeGuide) => DropdownMenuItem<SizeGuideModel>(
                value: sizeGuide, // Store full SizeGuideModel
                child: Text(sizeGuide.garmentType),
              ))
                  .toList(),
              onChanged: (SizeGuideModel? value) {
                if (value != null) {
                  CreateProductController.instance.selectedSizeGuide.value = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
