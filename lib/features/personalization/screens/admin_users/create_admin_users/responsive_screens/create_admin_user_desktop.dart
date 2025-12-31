import 'package:flutter/material.dart';

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
                heading: 'Create SizeGuide',
                breadcrumbItems: [RSRoutes.sizeGuide, 'Create SizeGuide'],
                onBack: () {
                  Get.offNamed(RSRoutes.sizeGuide);
                },

              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              CreateSizeGuideForm(),
            ],
          ),
        ),
      ),
    );
  }
}
