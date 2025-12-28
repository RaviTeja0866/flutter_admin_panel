import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/all_exchange/responsive_screens/exchange_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/all_exchange/responsive_screens/exchange_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/all_exchange/responsive_screens/exchange_tablet.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
        desktop: ExchangeDesktopScreen(),
        tablet: ExchangeTabletScreen(),
        mobile: ExchangeMobileScreen());
  }
}
