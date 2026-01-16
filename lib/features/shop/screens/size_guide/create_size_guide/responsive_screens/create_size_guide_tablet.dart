import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/create_shop_category/widgets/create_shop_category_form.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/create_size_guide/widgets/create_size_guide_form.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

class CreateSizeGuideTabletScreen extends StatelessWidget {
  const CreateSizeGuideTabletScreen({super.key});

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
                  heading: 'Create SizeGuide',
                  breadcrumbItems: [RSRoutes.shopCategory, 'Create SizeGuide'],
                onBack: () {
                  Get.offNamed(RSRoutes.sizeGuide);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              CreateSizeGuideForm(),
            ],
          ),
        ),
      ),
    );
  }
}
