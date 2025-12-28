import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/exchnage_details/responsive_screens/exchange_details_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/exchnage_details/responsive_screens/exchange_details_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/exchnage_details/responsive_screens/exchange_details_tablet.dart';

class ExchangeDetailScreen extends StatelessWidget {
  const ExchangeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exchangeOrder = Get.arguments;
    final exchangeOrderId = Get.parameters['orderId'];
    return RSSiteTemplate(
      desktop: ExchangeDetailsDesktopScreen(exchangeOrder: exchangeOrder),
      tablet: ExchangeDetailsTabletScreen(exchangeOrder: exchangeOrder),
      mobile: ExchangeDetailsMobileScreen(exchangeOrder: exchangeOrder),
    );
  }
}
