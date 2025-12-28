import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import '../../../../controllers/product/create_product_controller.dart';

class RSTargetAudienceWidget extends StatelessWidget {
  const RSTargetAudienceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final createProductController = Get.put(CreateProductController());

    // List of target audience options
    final targetAudiences = [
      'Men',
      'Women',
      'Unisex',
      'Kids',
    ];

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label for the target audience dropdown
          Text('Target Audience', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Dropdown for selecting the target audience
          Obx(
                () => DropdownButtonFormField<String>(
              value: createProductController.targetAudience.value,
              decoration: InputDecoration(
                labelText: 'Target Audience',
                border: OutlineInputBorder(),
              ),
              items: targetAudiences
                  .map((audience) => DropdownMenuItem<String>(
                value: audience,
                child: Text(audience),
              ))
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  createProductController.targetAudience.value = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
