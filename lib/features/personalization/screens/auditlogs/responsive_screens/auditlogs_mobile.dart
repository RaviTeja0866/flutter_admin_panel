import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/auditlog_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../table/data_table.dart';

class AuditlogsMobileScreen extends StatelessWidget {
  const AuditlogsMobileScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditLogController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // Breadcrumbs
              // -------------------------------------------------------------
              RSBreadcrumbsWithHeading(
                heading: 'AuditLogs',
                breadcrumbItems: ['AuditLogs'],
              ),
              SizedBox(height: RSSizes.spaceBtwSections),

              // -------------------------------------------------------------
              // Container with Search + Table
              // -------------------------------------------------------------
              RSRoundedContainer(
                child: Column(
                  children: [
                    // --------------------------
                    // Table Header + Search
                    // --------------------------
                    RSTableHeader(
                      showLeftWidget: false,
                      searchController: controller.searchController,
                      searchOnChanged: (query) => controller.searchQuery(query),
                    ),
                    SizedBox(height: RSSizes.spaceBtwItems),

                    // --------------------------
                    // Returns Table or Loader
                    // --------------------------
                    Obx(() {
                      if (controller.isLoading.value) {
                        return RSLoaderAnimation();
                      }

                      return const AuditLogsTable();
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
