import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/admin_users/all_admin_users/responsive_screens/admin_user_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/admin_users/all_admin_users/responsive_screens/admin_user_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/admin_users/all_admin_users/responsive_screens/admin_user_tablet.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: AdminUsersDesktopScreen(),
      tablet: AdminUsersTabletScreen(),
      mobile: AdminUsersMobileScreen(),
    );
  }
}
