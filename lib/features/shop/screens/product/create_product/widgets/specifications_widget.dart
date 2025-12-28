import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/specifications_controller.dart';

class ProductSpecificationsWidget extends StatelessWidget {
  const ProductSpecificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductSpecificationsController());

    return RSRoundedContainer(
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Specifications Title
            Text('Product Specifications', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: RSSizes.spaceBtwItems),

            // Description
            Text(
              'Select 6 specifications for your product. All fields are mandatory.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: RSSizes.spaceBtwItems),

            // 6 Specification Fields
            ...List.generate(6, (index) =>
                _buildSpecificationField(context, controller, index)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationField(BuildContext context, ProductSpecificationsController controller, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Specification dropdown and text field in a row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Specification Type Dropdown
            Expanded(
              flex: 2,
              child: Obx(() {
                // This line makes the Obx reactive to the updateTrigger
                controller.updateTrigger.value; // Just accessing it triggers reactivity

                return DropdownButtonFormField<String>(
                  value: controller.selectedTypes[index].isEmpty ? null : controller.selectedTypes[index],
                  validator: (value) => RSValidator.validateEmptyText('Specification type', value),
                  decoration: InputDecoration(
                    labelText: 'Specification Type',
                    hintText: 'Select type',
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                    ),
                  ),
                  items: controller.getAvailableTypes(index).map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.updateSelectedType(index, newValue);
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                );
              }),
            ),

            SizedBox(width: RSSizes.spaceBtwInputFields),

            // Specification Value Text Field
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller.valueControllers[index],
                validator: (value) => RSValidator.validateEmptyText('Value', value),
                decoration: InputDecoration(
                  labelText: 'Value',
                  hintText: 'Enter value',
                  errorStyle: TextStyle(
                    color: Colors.red.shade700,
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
          ],
        ),
        SizedBox(height: RSSizes.spaceBtwInputFields),
      ],
    );
  }
}