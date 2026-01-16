import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../personalization/models/admin_model.dart';
import '../../../../models/user_model.dart';
import '../widgets/customer_info.dart';
import '../widgets/customer_orders.dart';
import '../widgets/shipping_address.dart';

class CustomerDetailsTabletScreen extends StatelessWidget {
  const CustomerDetailsTabletScreen({super.key, required this.customer});

  final UserModel customer;

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
                  heading: 'Customers',
                  breadcrumbItems: [RSRoutes.customers, 'Details'],
                onBack: () {
                  Get.offNamed(RSRoutes.customers);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side Customer Information
                  Expanded(
                      child: Column(
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
                  Expanded(flex: 2, child: CustomerOrders())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
