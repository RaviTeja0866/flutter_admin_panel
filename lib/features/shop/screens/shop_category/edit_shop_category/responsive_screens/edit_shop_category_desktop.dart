
import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import 'package:roguestore_admin_panel/features/shop/models/shop_category.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/edit_shop_category/widgets/edit_shop_category_form.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

class EditShopCategoryDesktopScreen extends StatelessWidget {
  const EditShopCategoryDesktopScreen({super.key, required this.shopCategory});

  final ShopCategory shopCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(returnToPreviousScreen: true,heading: 'Update ShopCategory', breadcrumbItems: [RSRoutes.shopCategory, 'Update ShopCategory']),
              SizedBox(height: RSSizes.spaceBtwSections),

              EditShopCategoryForm(shopCategory: shopCategory),
            ],
          ),
        ),
      ),
    );
  }
}
