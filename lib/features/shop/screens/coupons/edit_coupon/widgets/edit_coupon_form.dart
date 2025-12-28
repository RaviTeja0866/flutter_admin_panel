import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/validators/validation.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../controllers/coupon/edit_coupon_contorller.dart';

class EditCouponForm extends StatelessWidget {
  final CouponModel coupon;

  const EditCouponForm({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditCouponController());
    // Initialize coupon data
    editController.initCoupon(coupon);

    return RSRoundedContainer(
      width: 500,
      padding: EdgeInsets.all(RSSizes.defaultSpace),
      child: Obx(
            () => Form(
          key: editController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              SizedBox(height: RSSizes.sm),
              Text('Edit Coupon', style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Coupon Code Text Field
              TextFormField(
                controller: editController.code,
                validator: (value) => RSValidator.validateEmptyText('Coupon Code', value),
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    labelText: 'Coupon Code', prefixIcon: Icon(Iconsax.ticket)),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Discount Type Dropdown
              DropdownButtonFormField<String>(
                value: editController.discountType.value,
                items: ['flat', 'percentage']
                    .map((e) => DropdownMenuItem<String>(value: e, child: Text(e.capitalize!)))
                    .toList(),
                onChanged: (value) => editController.discountType.value = value!,
                validator: (value) => value == null ? 'Please select a discount type' : null,
                decoration: InputDecoration(
                    labelText: 'Discount Type', prefixIcon: Icon(Iconsax.discount_shape)),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Discount Amount Text Field (depends on discount type)
              Obx(() {
                return TextFormField(
                  controller: editController.discountAmount,
                  validator: (value) => RSValidator.validatePositiveNumber('Discount Amount', value),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: editController.discountType.value == 'percentage'
                        ? 'Discount Percentage'
                        : 'Discount Amount',
                    prefixIcon: Icon(Iconsax.dollar_circle),
                  ),
                );
              }),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Minimum Purchase Text Field
              TextFormField(
                controller: editController.minimumPurchase,
                validator: (value) => RSValidator.validatePositiveNumber('Minimum Purchase', value),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Minimum Purchase', prefixIcon: Icon(Iconsax.ticket_star)),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Start Date Picker
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: editController.formatDate(editController.startDate.value)),
                onTap: () => editController.selectStartDate(context),
                decoration: InputDecoration(
                    labelText: 'Start Date', prefixIcon: Icon(Iconsax.calendar)),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // End Date Picker
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: editController.formatDate(editController.expiryDate.value)),
                onTap: () => editController.expiryDate(context as DateTime?),
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
                      controller: editController.termsController,
                      decoration: InputDecoration(
                        labelText: 'Add New a term',
                        prefixIcon: Icon(Iconsax.text),
                      ),
                    ),
                  ),
                  SizedBox(width: RSSizes.sm), // Space between the text field and button

                  // Add Term Button
                  ElevatedButton(
                    onPressed: () {
                      if (editController.termsController.text.isNotEmpty) {
                        editController.addTerm(); // Add the term to the list
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
                  itemCount: editController.offerTerms.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.check_circle_outline, color: RSColors.success),
                      title: Text(editController.offerTerms[index]),
                      trailing: IconButton(
                        icon: Icon(Iconsax.trash),
                        color: RSColors.error,
                        onPressed: () => editController.removeTerm(index),
                      ),
                      onTap: () {
                        // Edit Term functionality (optional)
                        editController.termsController.text = editController.offerTerms[index];
                        editController.removeTerm(index); // Optionally remove to edit and re-add
                      },
                    );
                  },
                );
              }),
              SizedBox(height: RSSizes.spaceBtwInputFields * 2),


              // IsActive Checkbox
              CheckboxListTile(
                value: editController.isActive.value,
                onChanged: (value) => editController.isActive.value = value ?? false,
                title: Text('Is Active'),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields * 2),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => editController.updateCoupon(coupon),
                  child: Text('Update'),
                ),
              ),

              SizedBox(height: RSSizes.spaceBtwInputFields * 2),
            ],
          ),
        ),
      ),
    );
  }
}
