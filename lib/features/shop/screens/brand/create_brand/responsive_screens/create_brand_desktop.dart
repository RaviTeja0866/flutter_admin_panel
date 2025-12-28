import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_brand_form.dart';

class CreateBrandDesktopScreen extends StatelessWidget {
  const CreateBrandDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BreadCrumbs
            RSBreadcrumbsWithHeading(returnToPreviousScreen: true,heading: 'Create Brand', breadcrumbItems: ['Create Brand']),
            SizedBox(height: RSSizes.spaceBtwSections),

            // Form
            CreateBrandForm(),

          ],
        ),
        ),
      ),
    );
  }
}
