import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/all_coupons/responsive_screens/coupon_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/all_coupons/responsive_screens/coupon_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/all_coupons/responsive_screens/coupon_tablet.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
        desktop: CouponDesktopScreen(),
        tablet: CouponTabletScreen(),
        mobile: CouponMobileScreen());
  }
}
