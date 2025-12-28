import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/edit_size_guide/responsive_screens/edit_size_guide_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/edit_size_guide/responsive_screens/edit_size_guide_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/edit_size_guide/responsive_screens/edit_size_guide_tablet.dart';

class EditSizeGuideScreen extends StatelessWidget {
  const EditSizeGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeGuide = Get.arguments;
    return RSSiteTemplate(
      desktop: EditSizeGuideDesktopScreen(sizeGuide: sizeGuide),
      tablet: EditSizeGuideTabletScreen(sizeGuide: sizeGuide),
      mobile: EditSizeGuideMobileScreen(sizeGuide: sizeGuide),
    );
  }
}
