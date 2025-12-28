import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/auditlog_controller.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/auditlogs/table/table_source.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';

class AuditLogsTable extends StatelessWidget {
  const AuditLogsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditLogController());

    return Obx(() {
      // Force reactive rebuild when counts change
      controller.filteredItems.length;
      controller.selectedRows.length;

      return RSPaginatedDataTable(
        minWidth: 700,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(label: Text('User')),
          DataColumn2(
            label: Text('Action'),
          ),
          DataColumn2(
            label: Text('Date&Time'),
            onSort: (columnIndex, ascending) =>
                controller.sortByDate(columnIndex, ascending),
          ),
          DataColumn2(
            label: Text('Subject'),
            fixedWidth: RSDeviceUtils.isMobileScreen(context) ? 120 : null,
          ),
          DataColumn2(label: Text('Browser')),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],
        source: AuditlogsRows(),
      );
    });
  }
}
