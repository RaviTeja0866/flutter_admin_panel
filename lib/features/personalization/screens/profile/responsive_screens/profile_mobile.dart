import 'package:flutter/material.dart';

import '../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../widgets/image_meta.dart';
import '../widgets/profile_form.dart';

class ProfileMobileScreen extends StatelessWidget {
  const ProfileMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Profile', breadcrumbItems: ['Profile']),
              SizedBox(height: RSSizes.spaceBtwSections),

              // Body
              Column(
                children: [
                  // Profile pic and meta
                  ImageAndMeta(),
                  SizedBox(width: RSSizes.spaceBtwSections),

                  // Form
                  ProfileForm()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
