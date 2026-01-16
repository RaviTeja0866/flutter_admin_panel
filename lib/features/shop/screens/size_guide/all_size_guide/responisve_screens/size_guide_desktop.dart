import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/size_guide/size_guide_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/all_size_guide/table/data_table.dart';
import 'package:roguestore_admin_panel/utils/popups/loader_animation.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../data/services.cloud_storage/RBAC/admin_screen_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class SizeGuideDesktopScreen extends StatelessWidget {
  const SizeGuideDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SizeGuideController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BreadCrumbs
              RSBreadcrumbsWithHeading(heading: 'Size Guide', breadcrumbItems: ['Size Guide']),
              SizedBox(height: RSSizes.spaceBtwItems),

              //Table Body
              Obx(() {
                // show Loader
                if(controller.isLoading.value) return RSLoaderAnimation();

                return RSRoundedContainer(
                  child: Column(
                    children: [
                      RSTableHeader(
                        searchOnChanged: (query) => controller.searchQuery(query),

                        primaryButton: AdminScreenGuard(
                          permission: Permission.sizeGuideCreate,
                          behavior: GuardBehavior.disable,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(RSRoutes.createSizeGuide),
                            child: const Text('Create New SizeGuide'),
                          ),
                        ),

                      ),
                      SizedBox(height: RSSizes.spaceBtwItems),

                      // Table
                      SizeGuideTable(),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
