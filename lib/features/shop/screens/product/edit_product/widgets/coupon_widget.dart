import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/edit_product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/utils/helpers/cloud_helper_functions.dart';
import 'package:roguestore_admin_panel/features/shop/models/product_model.dart';

class RSCouponWidget extends StatelessWidget {
  const RSCouponWidget({
    super.key,
    required this.product
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final productController = EditProductController.instance;

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coupon Label
          Text('Coupon', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Coupon selection using DropdownButton
          FutureBuilder<CouponModel?>(
            future: productController.loadSelectedCoupon(product.id),
            builder: (context, snapshot) {
              final widget = RSCloudHelperFunctions.checkSingleRecordState(snapshot);
              if (widget != null) return widget;

              return Obx(() {
                return DropdownButtonFormField<CouponModel>(
                  value: productController.selectedCoupon.value,
                  decoration: InputDecoration(
                    labelText: 'Select Coupon',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Iconsax.ticket),
                  ),
                  items: [
                    // Add a "No Coupon" option
                    DropdownMenuItem<CouponModel>(
                      value: null,
                      child: Text('No Coupon'),
                    ),
                    // Add all available coupons
                    ...CouponController.instance.allItems
                        .map((coupon) => DropdownMenuItem<CouponModel>(
                      value: coupon,
                      child: Text(coupon.title),
                    ))
                        .toList(),
                  ],
                  onChanged: (value) {
                    productController.selectedCoupon.value = value; // Set selected coupon
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }
}