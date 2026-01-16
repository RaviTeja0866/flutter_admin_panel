import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/coupon/edit_coupon_contorller.dart';
import '../../../../models/coupon_model.dart';
import '../widgets/edit_coupon_form.dart';

class EditCouponMobileScreen extends StatelessWidget {
  const EditCouponMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditCouponController.instance;

    return Obx(() {
      final coupon = controller.coupon.value;
      if (coupon == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BreadCrumbs
                RSBreadcrumbsWithHeading(
                    returnToPreviousScreen: true,
                    heading: 'Update Coupon',
                    breadcrumbItems: [RSRoutes.categories, 'Update Coupon'],
                  onBack: () {
                    Get.offNamed(RSRoutes.coupons);
                  },

                ),
                SizedBox(height: RSSizes.spaceBtwSections),

                EditCouponForm(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
