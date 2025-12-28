import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/edit_banner/widgets/edit_banner_form.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/banner_model.dart';

class EditBannerDesktopScreen extends StatelessWidget {
  const EditBannerDesktopScreen({super.key, required this.banner});

  final BannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,heading: 'Update Banner', breadcrumbItems: [RSRoutes.banners, 'Update Banner']),
              SizedBox(height: RSSizes.spaceBtwSections),

              EditBannerForm(banner: banner),
            ],
          ),
        ),
      ),
    );
  }
}
