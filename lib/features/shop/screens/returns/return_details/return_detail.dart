import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/return_details/responsive_screens/return_details_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/return_details/responsive_screens/return_details_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/return_details/responsive_screens/return_details_tablet.dart';

class ReturnDetailScreen extends StatelessWidget {
  const ReturnDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final returnOrder = Get.arguments;
    final returnOrderId = Get.parameters['orderId'];
    return RSSiteTemplate(
      desktop: ReturnDetailsDesktopScreen(returnOrder: returnOrder),
      tablet: ReturnDetailsTabletScreen(returnOrder: returnOrder),
      mobile: ReturnDetailsMobileScreen(returnOrder: returnOrder),
    );
  }
}
