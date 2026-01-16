import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/banner_model.dart';
import '../widgets/edit_banner_form.dart';

class EditBannerTabletScreen extends StatelessWidget {
  const EditBannerTabletScreen({super.key});

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
                  heading: 'Update Banner',
                  breadcrumbItems: [RSRoutes.banners, 'Update Banner'],
                onBack: (() => Get.offNamed(RSRoutes.banners)),

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              EditBannerForm(),
            ],
          ),
        ),
      ),
    );
  }
}
