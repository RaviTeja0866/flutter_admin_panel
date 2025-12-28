import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/category_model.dart';
import '../widgets/edit_category_form.dart';

class EditCategoryMobileScreen extends StatelessWidget {
  const EditCategoryMobileScreen({super.key, required this.category});

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
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,
                  heading: 'Create Category',
                  breadcrumbItems: [RSRoutes.categories, 'Create Category']),
              SizedBox(height: RSSizes.spaceBtwSections),

              EditCategoryForm(category: category),
            ],
          ),
        ),
      ),
    );
  }
}
