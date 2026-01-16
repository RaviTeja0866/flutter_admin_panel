import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/create_roles/responsive_screens/create_role_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/create_roles/responsive_screens/create_role_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/create_roles/responsive_screens/create_role_tablet.dart';

class CreateRolesScreen extends StatelessWidget {
  const CreateRolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: CreateRoleDesktopScreen(),
      tablet: CreateRoleTabletScreen(),
      mobile: CreateRoleMobileScreen(),
    );
  }
}
