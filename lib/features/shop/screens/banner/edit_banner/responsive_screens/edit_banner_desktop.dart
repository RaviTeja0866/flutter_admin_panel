import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/edit_banner/widgets/edit_banner_form.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/banner/edit_banner_controller.dart';
import '../../../../models/banner_model.dart';

class EditBannerDesktopScreen extends StatelessWidget {
  const EditBannerDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditBannerController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(
                heading: 'Edit Banner',
                breadcrumbItems: [RSRoutes.editBanner, 'Edit'],
                returnToPreviousScreen: true,
                onBack: () {
                  Get.offNamed(RSRoutes.banners);
                },
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
