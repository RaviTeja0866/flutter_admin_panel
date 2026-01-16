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
  const EditCouponForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditCouponController.instance;

    return Obx(() {
      final coupon = controller.coupon.value;

      // ⛔ Wait until coupon is loaded (refresh safe)
      if (coupon == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return RSRoundedContainer(
        width: 500,
        padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Coupon',
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Coupon Code
              TextFormField(
                controller: controller.code,
                validator: (v) =>
                    RSValidator.validateEmptyText('Coupon Code', v),
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Coupon Code',
                  prefixIcon: Icon(Iconsax.ticket),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Discount Type
              DropdownButtonFormField<String>(
                value: controller.discountType.value,
                items: const ['flat', 'percentage']
                    .map((e) =>
                    DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => controller.discountType.value = v!,
                decoration: const InputDecoration(
                  labelText: 'Discount Type',
                  prefixIcon: Icon(Iconsax.discount_shape),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Discount Value
              TextFormField(
                controller: controller.discountType.value == 'percentage'
                    ? controller.discountPercentage
                    : controller.discountAmount,
                validator: (v) =>
                    RSValidator.validatePositiveNumber('Discount', v),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: controller.discountType.value == 'percentage'
                      ? 'Discount Percentage'
                      : 'Discount Amount',
                  prefixIcon: const Icon(Iconsax.dollar_circle),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Minimum Purchase
              TextFormField(
                controller: controller.minimumPurchase,
                validator: (v) =>
                    RSValidator.validatePositiveNumber('Minimum Purchase', v),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Minimum Purchase',
                  prefixIcon: Icon(Iconsax.ticket_star),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Start Date
              TextFormField(
                controller: controller.startDateController,
                readOnly: true,
                onTap: () => controller.selectStartDate(context),
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: Icon(Iconsax.calendar),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // End Date
              TextFormField(
                controller: controller.endDateController,
                readOnly: true,
                onTap: () => controller.selectExpiryDate(context),
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  prefixIcon: Icon(Iconsax.calendar_2),
                ),
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Terms
              Text('Terms & Conditions',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: RSSizes.sm),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.termsController,
                      decoration: const InputDecoration(
                        labelText: 'Add term',
                        prefixIcon: Icon(Iconsax.text),
                      ),
                    ),
                  ),
                  SizedBox(width: RSSizes.sm),
                  ElevatedButton(
                    onPressed: controller.addTerm,
                    child: const Text('Add'),
                  ),
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              Obx(() => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.offerTerms.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(controller.offerTerms[i]),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.trash),
                    onPressed: () => controller.removeTerm(i),
                  ),
                ),
              )),

              SizedBox(height: RSSizes.spaceBtwInputFields),

              CheckboxListTile(
                value: controller.isActive.value,
                onChanged: (v) => controller.isActive.value = v ?? false,
                title: const Text('Active'),
              ),

              SizedBox(height: RSSizes.spaceBtwSections),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.updateCoupon,
                  child: const Text('Update Coupon'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
