import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles&permissions/create_admin_users/responsive_screens/create_roles_permissions_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles&permissions/create_admin_users/responsive_screens/create_roles_permissions_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles&permissions/create_admin_users/responsive_screens/create_roles_permissions_tablet.dart';

class CreateRolesPermissionsScreen extends StatelessWidget {
  const CreateRolesPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: CreateRolesPermissionsDesktopScreen(),
      tablet: CreateRolesPermissionsTabletScreen(),
      mobile: CreateRolesPermissionsMobileScreen(),
    );
  }
}
