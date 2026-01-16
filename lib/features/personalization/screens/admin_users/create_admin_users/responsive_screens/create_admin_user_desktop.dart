import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_admin_user_form.dart';

class CreateAdminUserDesktopScreen extends StatelessWidget {
  const CreateAdminUserDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Create Admin User',
                breadcrumbItems: [RSRoutes.adminUser, 'Create Admin User'],
                onBack: () {
                  Get.offNamed(RSRoutes.adminUser);
                },
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              CreateAdmminUserFormScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
