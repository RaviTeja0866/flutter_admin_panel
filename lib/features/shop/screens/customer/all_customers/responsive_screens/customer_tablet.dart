import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../table/data_table.dart';

class CustomerTabletScreen extends StatelessWidget {
  const CustomerTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Customers', breadcrumbItems: ['Customers']),
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
    );
  }
}
