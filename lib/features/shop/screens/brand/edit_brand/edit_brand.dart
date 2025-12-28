import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_brand_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_brand_mobille.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_brand_tablet.dart';


import '../../../models/brand_model.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Get.arguments;
    print('Get.arguments: $brand');
    if (brand is! BrandModel) {
      throw Exception(
          'Invalid argument: Expected a BrandModel but got ${brand.runtimeType}');
    }
    return RSSiteTemplate(
        desktop: EditBrandDesktopScreen(brand: brand),
        tablet: EditBrandTabletScreen(brand: brand),
        mobile: EditBrandMobileScreen(brand: brand));
  }
}
