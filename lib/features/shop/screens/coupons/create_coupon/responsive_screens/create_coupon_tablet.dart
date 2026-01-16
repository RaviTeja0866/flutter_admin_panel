import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../widgets/create_coupon_form.dart';

class CreateCouponTabletScreen extends StatelessWidget {
  const CreateCouponTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,
                  heading: 'Create Coupon',
                  breadcrumbItems: [RSRoutes.coupons, 'Create Coupon'],
                onBack: () {
                  Get.offNamed(RSRoutes.coupons);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              CreateCouponForm(),
            ],
          ),
        ),
      ),
    );
  }
}
