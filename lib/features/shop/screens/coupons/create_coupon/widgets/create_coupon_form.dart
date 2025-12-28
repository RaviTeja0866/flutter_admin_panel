import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';

import '../../../../controllers/coupon/create_coupon_controller.dart';

class CreateCouponForm extends StatelessWidget {
  const CreateCouponForm({super.key});

  @override
  Widget build(BuildContext context) {
    final createController = Get.put(CreateCouponController());

    return RSRoundedContainer(
      width: 500,
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Form(
        key: createController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            SizedBox(height: RSSizes.sm),
            Text('Create New Coupon', style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: RSSizes.spaceBtwSections),

            // Coupon Code Text Field
            TextFormField(
              controller: createController.code,
              validator: (value) => RSValidator.validateEmptyText('Coupon Code', value),
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                  labelText: 'Coupon Code', prefixIcon: Icon(Iconsax.ticket)),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Discount Type (either Flat or Percentage)
            DropdownButtonFormField<String>(
              value: createController.discountType.value,
              items: ['flat', 'percentage']
                  .map((e) => DropdownMenuItem<String>(value: e, child: Text(e.capitalize!)))
                  .toList(),
              onChanged: (value) => createController.discountType.value = value!,
              validator: (value) => value == null ? 'Please select a discount type' : null,
              decoration: InputDecoration(
                labelText: 'Discount Type',
                prefixIcon: Icon(Iconsax.discount_shape),
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Discount Amount Text Field (depends on discount type)
            Obx(() {
              return TextFormField(
                controller: createController.discountAmount,
                validator: (value) => RSValidator.validatePositiveNumber('Discount Amount', value),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: createController.discountType.value == 'percentage'
                      ? 'Discount Percentage'
                      : 'Discount Amount',
                  prefixIcon: Icon(Iconsax.dollar_circle),
                ),
              );
            }),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Minimum Purchase Amount Text Field
            TextFormField(
              controller: createController.minimumPurchase,
              validator: (value) => RSValidator.validatePositiveNumber('Minimum Purchase', value),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Minimum Purchase',
                prefixIcon: Icon(Iconsax.wallet),
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Start Date Picker
            TextFormField(
              readOnly: true,
              controller: createController.startDateController,
              onTap: () => createController.selectStartDate(context),
              decoration: InputDecoration(
                  labelText: 'Start Date', prefixIcon: Icon(Iconsax.calendar)),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // End Date Picker
            TextFormField(
              readOnly: true,
              controller: createController.endDateController,
              onTap: () => createController.selectExpiryDate(context),
              decoration: InputDecoration(
                  labelText: 'End Date', prefixIcon: Icon(Iconsax.calendar_2)),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // Terms and Conditions Section
            Text(
              'Terms & Conditions:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: RSSizes.sm),

            // Row to place Button and Text Field side by side
            Row(
              children: [
                // Add Term TextField
                Expanded(
                  child: TextFormField(
                    controller: createController.termsController,
                    decoration: InputDecoration(
                      labelText: 'Add a new term',
                      prefixIcon: Icon(Iconsax.text),
                    ),
                  ),
                ),
                SizedBox(width: RSSizes.sm), // Space between the text field and button

                // Add Term Button
                ElevatedButton(
                  onPressed: () {
                    if (createController.termsController.text.isNotEmpty) {
                      createController.addTerm(); // Add the term to the list
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields),

            // List of terms with delete functionality
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: createController.offerTerms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.check_circle_outline, color: RSColors.success),
                    title: Text(createController.offerTerms[index]),
                    trailing: IconButton(
                      icon: Icon(Iconsax.trash),
                      color: RSColors.error,
                      onPressed: () => createController.removeTerm(index),
                    ),
                    onTap: () {
                      // Edit Term functionality (optional)
                      createController.termsController.text = createController.offerTerms[index];
                      createController.removeTerm(index); // Optionally remove to edit and re-add
                    },
                  );
                },
              );
            }),
            SizedBox(height: RSSizes.spaceBtwInputFields * 2),

            // IsActive Checkbox
            Obx(
                  () => CheckboxListTile(
                value: createController.isActive.value,
                onChanged: (value) => createController.isActive.value = value ?? false,
                title: Text('Is Active'),
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields * 2),


            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => createController.createCoupon(),
                child: Text('Create'),
              ),
            ),
            SizedBox(height: RSSizes.spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}

