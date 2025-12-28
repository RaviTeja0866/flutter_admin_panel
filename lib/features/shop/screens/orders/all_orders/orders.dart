import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/all_orders/responsive_screens/orders_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/all_orders/responsive_screens/orders_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/all_orders/responsive_screens/orders_tablet.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
        desktop: OrdersDesktopScreen(),
        tablet: OrdersTabletScreen(),
        mobile: OrdersMobileScreen(),
    );
  }
}
