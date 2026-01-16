import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/brand/edit_brand_controller.dart';
import '../../../../models/brand_model.dart';
import '../widgets/edit_brand_form.dart';

class EditBrandMobileScreen extends StatelessWidget {
  const EditBrandMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditBrandController.instance;

    return Obx((){
      final brand = controller.brand.value;

      if (brand == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BreadCrumbs
                RSBreadcrumbsWithHeading(returnToPreviousScreen: true,heading: 'Update Brand', breadcrumbItems: ['Update Brand']),
                SizedBox(height: RSSizes.spaceBtwSections),

                // Form
                EditBrandForm(),

              ],
            ),
          ),
        ),
      );
  });
  }
}
