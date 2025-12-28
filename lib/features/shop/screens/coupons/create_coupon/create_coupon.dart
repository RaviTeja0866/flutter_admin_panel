import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/create_coupon/responsive_screens/create_coupon_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/create_coupon/responsive_screens/create_coupon_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/create_coupon/responsive_screens/create_coupon_tablet.dart';

class CreateCouponScreen extends StatelessWidget {
  const CreateCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
        desktop: CreateCouponDesktopScreen(),
        tablet: CreateCouponTabletScreen(),
        mobile: CreateCouponMobileScreen());
  }
}
