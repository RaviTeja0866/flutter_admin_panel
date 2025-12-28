import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/templates/site_layout.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/auditlogs/responsive_screens/auditlogs_desktop.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/auditlogs/responsive_screens/auditlogs_mobile.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/auditlogs/responsive_screens/auditlogs_tablet.dart';

class AuditlogsScreen extends StatelessWidget {
  const AuditlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RSSiteTemplate(
      desktop: AuditlogsDesktopScreen(),
      tablet: AuditlogsTabletScreen(),
      mobile: AuditlogsMobileScreen(),
    );
  }
}
