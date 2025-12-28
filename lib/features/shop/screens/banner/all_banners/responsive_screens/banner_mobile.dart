import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../../../../controllers/banner/banner_controller.dart';
import '../table/data_table.dart';

class BannerMobileScreen extends StatelessWidget {
  const BannerMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Banners', breadcrumbItems: ['Banners']),
              SizedBox(height: RSSizes.spaceBtwItems),

              //Table Body
              Obx(() {
                // show Loader
                if(controller.isLoading.value) return RSLoaderAnimation();

                return RSRoundedContainer(
                  child: Column(
                    children: [
                      RSTableHeader(buttonText: 'Create New Banner', onPressed: () => Get.toNamed(RSRoutes.createBanner)),
                      SizedBox(height: RSSizes.spaceBtwItems),

                      // Table
                      BannerTable(),
                    ],
                  ),
                );
              })


            ],
          ),
        ),
      ),
    );
  }
}
