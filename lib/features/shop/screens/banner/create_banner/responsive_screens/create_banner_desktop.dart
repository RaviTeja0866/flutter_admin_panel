import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/banner/create_banner_controller.dart';
import '../widgets/create_banner_form.dart';

class CreateBannerDesktopScreen extends StatelessWidget {
  const CreateBannerDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateBannerController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(
                heading: 'Create Banner',
                breadcrumbItems: [RSRoutes.createBanner, 'Create'],
                returnToPreviousScreen: true,
                onBack: () {
                  Get.offNamed(RSRoutes.banners);
                },
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              CreateBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
