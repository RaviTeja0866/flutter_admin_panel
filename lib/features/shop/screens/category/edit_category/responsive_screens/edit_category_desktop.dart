import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../models/category_model.dart';
import '../widgets/edit_category_form.dart';

class EditCategoryDesktopScreen extends StatelessWidget {
  const EditCategoryDesktopScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,heading: 'Update Category', breadcrumbItems: [RSRoutes.categories, 'Update Category']),
              SizedBox(height: RSSizes.spaceBtwSections),

              EditCategoryForm(category:category),
            ],
          ),
        ),
      ),
    );
  }
}
