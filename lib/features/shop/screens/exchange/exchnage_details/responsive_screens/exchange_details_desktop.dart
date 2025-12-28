
import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/features/shop/models/exchange_model.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/exchange_customer_info.dart';
import '../widgets/exchange_order_info.dart';
import '../widgets/exchange_order_items.dart';
import '../widgets/exchange_order_timeline.dart';

class ExchangeDetailsDesktopScreen extends StatelessWidget {
  const ExchangeDetailsDesktopScreen({
    super.key,
    required this.exchangeOrder,
  });

  final ExchangeRequestModel exchangeOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------------------------
              // Breadcrumbs
              // ------------------------------------------------------------------
              RSBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: exchangeOrder.id,
                breadcrumbItems: [RSRoutes.exchange],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // ------------------------------------------------------------------
              // Body: 2 Column Layout
              // ------------------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------------------------------------------------------
                  // LEFT SIDE (Exchange Info, Items, Timeline)
                  // --------------------------------------------------------------
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Exchange Info
                        ExchangeOrderInfo(exchangeOrder: exchangeOrder),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        // Exchange Item Summary
                        ExchangeOrderItems(exchangeOrder: exchangeOrder),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        // Exchange Timeline
                        ExchangeOrderTimeline(exchange: exchangeOrder),
                      ],
                    ),
                  ),

                  SizedBox(width: RSSizes.spaceBtwSections),

                  // --------------------------------------------------------------
                  // RIGHT SIDE (Customer Info)
                  // --------------------------------------------------------------
                  Expanded(
                    child: Column(
                      children: [
                        ExchangeCustomer(exchange: exchangeOrder),
                        SizedBox(height: RSSizes.spaceBtwSections),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
