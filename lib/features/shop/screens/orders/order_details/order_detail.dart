import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/order_details/responsive_screens/order_details_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/order_details/responsive_screens/order_details_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/order_details/responsive_screens/order_details_tablet.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    final orderId = Get.parameters['orderId'];
    return RSSiteTemplate(
      desktop: OrderDetailsDesktopScreen(order:order),
      tablet: OrderDetailsTabletScreen(order:order),
      mobile: OrderDetailsMobileScreen(order:order),
    );
  }
}
