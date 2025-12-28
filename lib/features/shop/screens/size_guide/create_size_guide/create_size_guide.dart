import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/create_shop_category/responsive_screens/create_shop_category_mobile.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/create_size_guide/responsive_screens/create_size_guide_desktop.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/create_size_guide/responsive_screens/create_size_guide_tablet.dart';

class CreateSizeGuideScreen extends StatelessWidget {
  const CreateSizeGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: CreateSizeGuideDesktopScreen(),
      tablet: CreateSizeGuideTabletScreen(),
      mobile: CreateShopCategoryMobileScreen(),
    );
  }
}
