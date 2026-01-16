import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/edit_roles/responsive_screens/edit_role_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/edit_roles/responsive_screens/edit_role_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/roles/edit_roles/responsive_screens/edit_role_tablet.dart';

class EditRolesScreen extends StatelessWidget {
  const EditRolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: EditRoleDesktopScreen(),
      tablet: EditRoleTabletScreen(),
      mobile: EditRoleMobileScreen(),
    );
  }
}
