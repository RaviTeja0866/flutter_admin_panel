import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../controllers/category/edit_category_controller.dart';
import '../../../../models/category_model.dart';
import '../widgets/edit_category_form.dart';

class EditCategoryDesktopScreen extends StatelessWidget {
  const EditCategoryDesktopScreen({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditCategoryController());

    controller.loadCategory(categoryId);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RSBreadcrumbsWithHeading(
                heading: 'Update Category',
                breadcrumbItems: [
                  RSRoutes.categories,
                  'Update Category',
                ],
                returnToPreviousScreen: true,
                onBack: () {
                  Get.offNamed(RSRoutes.categories);
                },
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              Obx(() {
                if (controller.category.value == null) {
                  return const Center(child: CircularProgressIndicator());
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
