import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customer_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customer_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/customer/all_customers/responsive_screens/customer_tablet.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
        desktop: CustomerDesktopScreen(),
        tablet: CustomerTabletScreen(),
        mobile: CustomerMobileScreen());
  }
}
