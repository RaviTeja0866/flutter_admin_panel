
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/edit_coupon/responsive_screens/edit_coupon_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/edit_coupon/responsive_screens/edit_coupon_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/edit_coupon/responsive_screens/edit_coupon_tablet.dart';

class EditCouponScreen extends StatelessWidget {
  const EditCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coupon = Get.arguments;

    return RSSiteTemplate(
      desktop: EditCouponDesktopScreen(coupon: coupon),
      tablet: EditCouponTabletScreen(coupon: coupon),
      mobile: EditCouponMobileScreen(coupon: coupon),
    );
  }
}
