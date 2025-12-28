import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/personalization/models/user_model.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/customer/customer_detail_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';

class CustomerDetailsDesktopScreen extends StatelessWidget {
  const CustomerDetailsDesktopScreen({super.key, required this.customer});

  final UserModel customer;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerDetailController());
    controller.customer.value = customer;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: customer.fullName, breadcrumbItems: [RSRoutes.customers, 'Details']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side Customer Information
                  Expanded(child: Column(
                    children: [
                      // Customer info
                      CustomerInfo(customer: customer),
                      SizedBox(height: RSSizes.spaceBtwSections),

                      // Shipping Address
                      ShippingAddress(),
                    ],
                  )),
                  SizedBox(width: RSSizes.spaceBtwSections),

                  // Right side Customer Orders
                  Expanded(flex: 2,child: CustomerOrders())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
