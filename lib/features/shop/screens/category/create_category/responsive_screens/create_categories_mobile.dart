import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_category_form.dart';

class CreateCategoriesMobileScreen extends StatelessWidget {
  const CreateCategoriesMobileScreen({super.key});

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
                  heading: 'Create Category',
                  breadcrumbItems: [RSRoutes.categories, 'Create Category'],
                onBack: () {
                  Get.offNamed(RSRoutes.categories);
                },
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              CreateCategoryForm(),
            ],
          ),
        ),
      ),
    );
  }
}
