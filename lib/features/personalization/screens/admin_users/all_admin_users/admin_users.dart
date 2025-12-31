import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles&permissions/all_admin_users/responsive_screens/r&p_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles&permissions/all_admin_users/responsive_screens/r&p_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles&permissions/all_admin_users/responsive_screens/r&p_tablet.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: RolesAndPermissonsDesktopScreen(),
      tablet: RolesAndPermissionsTabletScreen(),
      mobile: RolesAndPermissionsMobileScreen(),
    );
  }
}
