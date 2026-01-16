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

class CustomerDetailsMobileScreen extends StatelessWidget {
  const CustomerDetailsMobileScreen({super.key, required this.customer});

  final UserModel customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,
                  heading: 'Roguestore Admin',
                  breadcrumbItems: [RSRoutes.customers, 'Details'],
                onBack: () {
                  Get.offNamed(RSRoutes.customers);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Body
              CustomerInfo(customer: customer),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Shipping Address
              ShippingAddress(),
              SizedBox(width: RSSizes.spaceBtwSections),

              // Right side Customer Orders
              CustomerOrders()
            ],
          ),
        ),
      ),
    );
  }
}
