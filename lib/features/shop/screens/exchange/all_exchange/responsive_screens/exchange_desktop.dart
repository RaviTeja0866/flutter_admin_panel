import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/exchange/exchange_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../table/data_table.dart';

class ExchangeDesktopScreen extends StatelessWidget {
  const ExchangeDesktopScreen({super.key});

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
                child: Column(
                  children: [
                    //Table
                    Obx(() {
                      if (controller.isLoading.value) return RSLoaderAnimation();

                      // Table
                      return ExchangeTable();
                    })
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
