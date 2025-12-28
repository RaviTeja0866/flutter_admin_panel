import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/features/shop/models/brand_model.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/edit_brand_form.dart';

class EditBrandDesktopScreen extends StatelessWidget {
  const EditBrandDesktopScreen({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Update Brand', breadcrumbItems: ['Update Brand']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Form
             EditBrandForm(brand: brand),

            ],
          ),
        ),
      ),
    );
  }
}
