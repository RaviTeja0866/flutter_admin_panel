import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/all_roles/responsive_screens/roles_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/all_roles/responsive_screens/roles_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/all_roles/responsive_screens/roles_tablet.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: RolesDesktopScreen(),
      tablet: RolesTabletScreen(),
      mobile: RolesMobileScreen(),
    );
  }
}
