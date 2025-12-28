import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../widgets/create_category_form.dart';

class CreateCategoriesDesktopScreen extends StatelessWidget {
  const CreateCategoriesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BreadCrumbs
            RSBreadcrumbsWithHeading(returnToPreviousScreen: true, heading: 'Create Category', breadcrumbItems: [RSRoutes.categories, 'Create Category']),
            SizedBox(height: RSSizes.spaceBtwSections),

            CreateCategoryForm(),
          ],
        ),
        ),
      ),
    );
  }
}
