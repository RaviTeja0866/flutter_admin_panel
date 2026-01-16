import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_brand_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_brand_mobille.dart';
import 'package:roguestore_admin_panel/features/shop/screens/brand/edit_brand/responsive_screens/edit_brand_tablet.dart';


import '../../../controllers/brand/edit_brand_controller.dart';
import '../../../models/brand_model.dart';

class EditBrandScreen extends StatelessWidget {
  const EditBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandId = Get.parameters['id']!;

    // ✅ LOAD BRAND ONCE
    final controller = Get.put(EditBrandController());
    controller.loadBrand(brandId);

    return RSSiteTemplate(
      desktop: const EditBrandDesktopScreen(),
      tablet: const EditBrandTabletScreen(),
      mobile: const EditBrandMobileScreen(),
    );
  }
}
