import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/settings/widgets/settings_form.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/image_and_meta.dart';

class SettingsDesktopScreen extends StatelessWidget {
  const SettingsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Settings', breadcrumbItems: ['Settings']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Body
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile pic and meta
                  Expanded(child: ImageAndMeta()),
                  SizedBox(width: RSSizes.spaceBtwSections),

                  // Form
                  Expanded(flex: 2,child: SettingsForm())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
