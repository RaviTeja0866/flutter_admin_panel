import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class CustomerTabletScreen extends StatelessWidget {
  const CustomerTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminScreenGuard(
        permission: Permission.customerView,
        behavior: GuardBehavior.denyScreen,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BreadCrumbs
                RSBreadcrumbsWithHeading(
                    heading: 'Customers', breadcrumbItems: ['Customers']),
                SizedBox(height: RSSizes.spaceBtwSections),

                RSRoundedContainer(
                  child: Column(
                    children: [
                      // Table Header
                      RSTableHeader(showLeftWidget: false),
                      SizedBox(height: RSSizes.spaceBtwItems),

                      CustomerTable(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
