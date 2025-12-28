import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/exchange/exchange_controller.dart';
import '../table/data_table.dart';

class ExchangeTabletScreen extends StatelessWidget {
  const ExchangeTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExchangeController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(
                  heading: 'Exchange', breadcrumbItems: ['Exchange']),
              SizedBox(height: RSSizes.spaceBtwSections),

              RSRoundedContainer(
                  child: Column(children: [
                    RSTableHeader(showLeftWidget: false),
                    SizedBox(height: RSSizes.spaceBtwItems),
                    ExchangeTable(),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
