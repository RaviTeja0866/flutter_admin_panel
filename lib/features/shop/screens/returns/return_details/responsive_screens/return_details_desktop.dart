import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/features/shop/models/return_model.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/return_details/widgets/return_order_info.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/return_customer_info.dart';
import '../widgets/return_order_items.dart';
import '../widgets/return_order_timeline.dart';
import '../widgets/return_order_transactions.dart';

class ReturnDetailsDesktopScreen extends StatelessWidget {
  const ReturnDetailsDesktopScreen({super.key, required this.returnOrder});

  final ReturnModel returnOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: "Return #${returnOrder.id}",
                breadcrumbItems: [RSRoutes.returns],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT SIDE
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        ReturnOrderInfo(returnOrder: returnOrder),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        ReturnOrderItemsCard(returnOrder: returnOrder),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        ReturnOrderTransactions(returnOrder: returnOrder),
                        SizedBox(height: RSSizes.spaceBtwSections),
                      ],
                    ),
                  ),

                  SizedBox(width: RSSizes.spaceBtwSections),

                  // RIGHT SIDE
                  Expanded(
                    child: Column(
                      children: [
                        ReturnsCustomer(returnOrder: returnOrder),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        ReturnTimeline(returnOrder: returnOrder),
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
