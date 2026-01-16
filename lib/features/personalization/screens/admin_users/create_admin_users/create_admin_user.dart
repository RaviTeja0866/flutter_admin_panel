import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/admin_users/create_admin_users/responsive_screens/create_admin_user_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/admin_users/create_admin_users/responsive_screens/create_admin_user_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/admin_users/create_admin_users/responsive_screens/create_admin_user_tablet.dart';

class CreateAdminUsersScreen extends StatelessWidget {
  const CreateAdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: CreateAdminUserDesktopScreen(),
      tablet: CreateAdminUserTabletScreen(),
      mobile: CreateAdminUserMobileScreen(),
    );
  }
}
