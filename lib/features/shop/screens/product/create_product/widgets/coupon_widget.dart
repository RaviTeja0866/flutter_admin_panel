import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/shimmers/shimmer_effect.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/product/create_product_controller.dart';
import '../../../../models/coupon_model.dart';

class RSCouponWidget extends StatelessWidget {
  const RSCouponWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = Get.put(CouponController());

    // Fetch coupons if the list is empty
    if (couponController.allItems.isEmpty) {
      couponController.fetchItems();
    }

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coupon label
          Text('Coupon', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // Dropdown for selecting a coupon
          Obx(
                () => couponController.isLoading.value
                ? RSShimmerEffect(width: double.infinity, height: 50)
                : DropdownButtonFormField<CouponModel>(
              value: CreateProductController.instance.selectedCoupon.value,
              decoration: InputDecoration(
                labelText: 'Select Coupon',
                border: OutlineInputBorder(),
              ),
              items: couponController.allItems
                  .map((coupon) => DropdownMenuItem<CouponModel>(
                value: coupon,
                child: Text(coupon.title),
              ))
                  .toList(),
              onChanged: (CouponModel? value) {
                if (value != null) {
                  CreateProductController.instance.selectedCoupon.value = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
