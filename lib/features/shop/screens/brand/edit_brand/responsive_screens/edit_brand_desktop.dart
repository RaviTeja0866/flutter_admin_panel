import 'package:flutter/material.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/brand/edit_brand_controller.dart';
import '../widgets/edit_brand_form.dart';

import 'package:get/get.dart';

class EditBrandDesktopScreen extends StatelessWidget {
  const EditBrandDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditBrandController.instance;

    return Obx(() {
      final brand = controller.brand.value;

      if (brand == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RSBreadcrumbsWithHeading(
                  returnToPreviousScreen: true,
                  heading: 'Update Brand',
                  breadcrumbItems: ['Brands', 'Update Brand'],
                  onBack: (() => Get.offNamed(RSRoutes.brands)),
                ),
                SizedBox(height: RSSizes.spaceBtwSections),

                // ✅ Controller-backed form
                EditBrandForm(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
