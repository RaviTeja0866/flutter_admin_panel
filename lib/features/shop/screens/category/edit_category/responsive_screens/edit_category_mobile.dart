import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/category/edit_category_controller.dart';
import '../widgets/edit_category_form.dart';

class EditCategoryMobileScreen extends StatelessWidget {
  const EditCategoryMobileScreen({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditCategoryController());

    // 🔑 Load category once (safe on rebuild)
    controller.loadCategory(categoryId);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RSBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Update Category',
                breadcrumbItems: [
                  RSRoutes.categories,
                  'Update Category',
                ],
                onBack: () {
                  Get.offNamed(RSRoutes.categories);
                },
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              Obx(() {
                if (controller.category.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return EditCategoryForm(
                  category: controller.category.value!,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
