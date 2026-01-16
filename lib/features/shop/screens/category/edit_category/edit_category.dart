import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';
import 'package:roguestore_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/category/edit_category/responsive_screens/edit_category_tablet.dart';

class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.parameters['id']!;

    return RSSiteTemplate(
      desktop: EditCategoryDesktopScreen(categoryId: categoryId),
      tablet: EditCategoryTabletScreen(categoryId: categoryId),
      mobile: EditCategoryMobileScreen(categoryId: categoryId),
    );
  }
}

