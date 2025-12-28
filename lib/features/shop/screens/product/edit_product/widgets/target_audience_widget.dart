import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

class RSTargetAudienceWidget extends StatelessWidget {
  final String initialTargetAudience;

  const RSTargetAudienceWidget(
      {super.key, required this.initialTargetAudience});

  @override
  Widget build(BuildContext context) {
    // Get the EditProductController for managing state
    final editProductController = Get.put(EditProductController());

    // Initialize the target audience with the passed value when editing a product
    if (editProductController.targetAudience.value.isEmpty) {
      editProductController.targetAudience.value = initialTargetAudience;
    }

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
          Text('Target Audience',
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Dropdown for selecting the target audience
          Obx(
            () => DropdownButtonFormField<String>(
              value: editProductController.targetAudience.value,
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
                  // Update the target audience in the controller
                  editProductController.targetAudience.value = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
