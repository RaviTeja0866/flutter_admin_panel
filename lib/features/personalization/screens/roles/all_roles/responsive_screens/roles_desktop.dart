import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../../../../controllers/roles/role_controller.dart';
import '../table/data_table.dart';

class RolesDesktopScreen extends StatelessWidget {
  const RolesDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RolesController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------
              // Breadcrumbs
              // ------------------------
              RSBreadcrumbsWithHeading(
                heading: 'Roles',
                breadcrumbItems: ['Roles'],
                returnToPreviousScreen: true,
                onBack: () => Get.offNamed(RSRoutes.roles),
              ),

              SizedBox(height: RSSizes.spaceBtwSections),

              // -------------------------
              // Table Container
              // --------------------------
              RSRoundedContainer(
                child: Column(
                  children: [
                    // Table Header
                    RSTableHeader(
                      searchOnChanged: controller.searchQuery,
                      primaryButton: AdminScreenGuard(
                        permission: Permission.roleCreate,
                        behavior: GuardBehavior.disable,
                        child: ElevatedButton(
                          onPressed: () =>
                              Get.toNamed(RSRoutes.createRole),
                          child: const Text('Create Role'),
                        ),
                      ),
                    ),

                    SizedBox(height: RSSizes.spaceBtwItems),

                    // Table / Loader
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const RSLoaderAnimation();
                      }
                      return const RolesTable();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
