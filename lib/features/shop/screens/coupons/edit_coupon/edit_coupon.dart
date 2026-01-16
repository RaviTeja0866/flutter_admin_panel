
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/edit_coupon/responsive_screens/edit_coupon_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/edit_coupon/responsive_screens/edit_coupon_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/edit_coupon/responsive_screens/edit_coupon_tablet.dart';

import '../../../controllers/coupon/edit_coupon_contorller.dart';

class EditCouponScreen extends StatelessWidget {
  const EditCouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final couponId = Get.parameters['id']; // ✅ URL param

    if (couponId == null) {
      return const Scaffold(
        body: Center(child: Text('Invalid Coupon ID')),
      );
    }

    final controller = Get.put(EditCouponController());
    controller.loadCoupon(couponId); // ✅ fetch from Firestore

    return const RSSiteTemplate(
      desktop: EditCouponDesktopScreen(),
      tablet: EditCouponTabletScreen(),
      mobile: EditCouponMobileScreen(),
    );
  }
}

