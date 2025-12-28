import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/auditlog_controller.dart';

import '../../../../../../common/widgets/breadcrumbs/breadcrumb_with_heading.dart';
import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/data_table/table_header.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/popups/loader_animation.dart';
import '../table/data_table.dart';

class AuditlogsDesktopScreen extends StatelessWidget {
  const AuditlogsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditLogController());

    return Scaffold(
      endDrawer: const AuditLogsExportDrawer(), // 👈 RIGHT PANEL
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(RSSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RSBreadcrumbsWithHeading(
                heading: 'AuditLogs',
                breadcrumbItems: ['AuditLogs'],
              ),

              SizedBox(height: RSSizes.spaceBtwSections),

              RSRoundedContainer(
                child: Column(
                  children: [
                    Builder(
                      builder: (scaffoldContext) {
                        return RSTableHeader(
                          buttonText: 'Export Logs',
                          onPressed: () {
                            Scaffold.of(scaffoldContext).openEndDrawer();
                            print('drawer Opened');
                          },
                          searchController: controller.searchController,
                          searchOnChanged: controller.searchQuery,
                        );
                      },
                    ),
                    SizedBox(height: RSSizes.spaceBtwItems),

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

class AuditLogsExportDrawer extends StatelessWidget {
  const AuditLogsExportDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 420,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Export documents',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Creates a ZIP file including all audit logs for the selected period.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Create new Export'),
              onPressed: () {
                // Call API → start export
              },
            ),

            const SizedBox(height: 32),

            Text(
              'Previous exports',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Center(
                child: Text(
                  'No exports yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
