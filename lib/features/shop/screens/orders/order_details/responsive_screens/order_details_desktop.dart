import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/all_orders/orders.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/customer_info.dart';
import '../widgets/order_info.dart';
import '../widgets/order_items.dart';
import '../widgets/order_transactions.dart';

class OrderDetailsDesktopScreen extends StatelessWidget {
  const OrderDetailsDesktopScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
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
                heading: order.id,
                breadcrumbItems: [RSRoutes.orders, 'Details'],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side order Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        // Order info
                        OrderInfo(order: order),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        // Items
                        OrderItems(order: order),
                        SizedBox(height: RSSizes.spaceBtwSections),

                        // Transactions
                        OrderTransactions(order: order),
                      ],
                    ),
                  ),
                  SizedBox(width: RSSizes.spaceBtwSections),

                  // Right side Order
                  Expanded(
                    child: Column(
                      children: [
                        OrderCustomer(),
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
