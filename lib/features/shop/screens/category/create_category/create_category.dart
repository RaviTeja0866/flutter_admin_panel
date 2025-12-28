import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_categories_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_categories_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/category/create_category/responsive_screens/create_categories_tablet.dart';

class CreateCategoryScreen extends StatelessWidget {
  const CreateCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
        desktop: CreateCategoriesDesktopScreen(),
        tablet: CreateCategoriesTabletScreen(),
        mobile: CreateCategoriesMobileScreen());
  }
}
