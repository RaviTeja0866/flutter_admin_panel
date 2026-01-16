import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/edit_banner/responsive_screens/edit_banner_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/edit_banner/responsive_screens/edit_banner_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/banner/edit_banner/responsive_screens/edit_banner_tablet.dart';

import '../../../controllers/banner/edit_banner_controller.dart';

class EditBannerScreen extends StatelessWidget {
  const EditBannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerId = Get.parameters['id']!;
    final controller = Get.put(EditBannerController());

    controller.loadBanner(bannerId); // fetch from Firestore

    return RSSiteTemplate(
      desktop: const EditBannerDesktopScreen(),
      tablet: const EditBannerTabletScreen(),
      mobile: const EditBannerMobileScreen(),
    );
  }
}
