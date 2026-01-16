import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../widgets/create_role_form.dart';

class CreateRoleDesktopScreen extends StatelessWidget {
  const CreateRoleDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------
              // Breadcrumbs
              // ---------------------------------
              RSBreadcrumbsWithHeading(
                returnToPreviousScreen: true,
                heading: 'Create Role',
                breadcrumbItems: [RSRoutes.roles, 'Create Role'],
                onBack: () {
                  Get.offNamed(RSRoutes.roles);
                },
              ),

              SizedBox(height: RSSizes.spaceBtwSections),

              // ---------------------------------
              // Create Role Form
              // ---------------------------------
              CreateRoleFormScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
