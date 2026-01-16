import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/create_shop_category/widgets/create_shop_category_form.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

class CreateShopCategoryDesktopScreen extends StatelessWidget {
  const CreateShopCategoryDesktopScreen({super.key});

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
                  heading: 'Create ShopCategory',
                  breadcrumbItems: [
                    RSRoutes.shopCategory,
                    'Create ShopCategory'
                  ],
                returnToPreviousScreen: true,
                onBack: () {
                  Get.offNamed(RSRoutes.shopCategory);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              CreateShopCategoryForm(),
            ],
          ),
        ),
      ),
    );
  }
}
