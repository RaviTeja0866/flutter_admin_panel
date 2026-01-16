import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/models/brand_model.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/edit_brand/widgets/edit_brand_form.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/brand/edit_brand_controller.dart';

class EditBrandTabletScreen extends StatelessWidget {
  const EditBrandTabletScreen({super.key});

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
