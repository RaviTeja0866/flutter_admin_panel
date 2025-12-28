import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/specifications_controller.dart';

class RSProductSpecificationsWidget extends StatelessWidget {
  const RSProductSpecificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the specifications controller (same pattern as ProductTitleAndDescription)
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
              'Select up to 6 specifications for your product.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: RSSizes.spaceBtwItems),

            // Debug info to show if specs were loaded
            Obx(() => controller.hasSpecsBeenLoaded.value
                ? Text('✓ Specifications loaded',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                : const SizedBox.shrink()),
            SizedBox(height: RSSizes.spaceBtwItems),

            // 6 Specification Fields - wrapped in Obx to rebuild when updateTrigger changes
            Obx(() {
              // This will trigger rebuild when updateTrigger changes
              controller.updateTrigger.value; // Access to make it reactive
              return Column(
                children: List.generate(6, (index) =>
                    _buildSpecificationField(context, controller, index)
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationField(BuildContext context, ProductSpecificationsController controller, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Dropdown
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: controller.selectedTypes[index].isEmpty ? null : controller.selectedTypes[index],
                validator: (value) => index == 0
                    ? RSValidator.validateEmptyText('Specification type', value)
                    : controller.selectedTypes[index].isEmpty
                    ? null
                    : RSValidator.validateEmptyText('Specification type', value),
                decoration: InputDecoration(
                  labelText: 'Specification Type',
                  hintText: 'Select type',
                  errorStyle: TextStyle(color: Colors.red.shade700),
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
              ),
            ),
            SizedBox(width: RSSizes.spaceBtwInputFields),

            /// Text Field (similar to your title/description - directly bound to controller)
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller.valueControllers[index],
                validator: (value) => controller.selectedTypes[index].isEmpty
                    ? null
                    : RSValidator.validateEmptyText('Value', value),
                decoration: InputDecoration(
                  labelText: 'Value',
                  hintText: 'Enter value',
                  errorStyle: TextStyle(color: Colors.red.shade700),
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