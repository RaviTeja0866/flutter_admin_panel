import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/coupon_model.dart';
import '../widgets/edit_coupon_form.dart';

class EditCouponTabletScreen extends StatelessWidget {
  const EditCouponTabletScreen({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,heading: 'Update Coupon', breadcrumbItems: [RSRoutes.categories, 'Update Coupon']),
              SizedBox(height: RSSizes.spaceBtwSections),

              EditCouponForm(coupon: coupon),
            ],
          ),
        ),
      ),
    );
  }
}
