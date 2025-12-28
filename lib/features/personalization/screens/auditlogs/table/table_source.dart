import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/table_action_buttons.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/auditlog_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';

class AuditlogsRows extends DataTableSource {
  final controller = AuditLogController.instance;

  @override
  DataRow getRow(int index) {
    final item = controller.filteredItems[index];

    return DataRow2(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
      controller.selectedRows[index] = value ?? false,
      cells: [
        // 1. Log ID
        DataCell(
          Text(
            item.id ?? '--',
            style: Theme.of(Get.context!)
                .textTheme
                .bodyMedium!
                .copyWith(color: RSColors.primary),
          ),
        ),

        // 2. User
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.userName,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                item.userEmail,
                style: Theme.of(Get.context!)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: RSColors.textSecondary),
              ),
            ],
          ),
        ),

        // 3. Action
        DataCell(
          RSRoundedContainer(
            radius: RSSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: RSSizes.sm,
              horizontal: RSSizes.md,
            ),
            backgroundColor:
            _actionColor(item.action).withOpacity(0.1),
            child: Text(
              item.action.capitalize!,
              style: TextStyle(
                color: _actionColor(item.action),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // 4. Subject
        DataCell(
          Text(
            item.subject,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // 5. Date & Time
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.formattedDate),
              Text(
                item.formattedTime,
                style: Theme.of(Get.context!)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: RSColors.textSecondary),
              ),
            ],
          ),
        ),

        // 6. Browser
        DataCell(
          Text(item.browser),
        ),

        // 7. Actions
        DataCell(
          RSTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () {
              // optional: show details dialog
            },
            onDeletePressed: () =>
                controller.confirmAndDeleteItem(item),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount =>
      controller.selectedRows.where((x) => x).length;

  // ---------------------------------------------------------------------------
  // ACTION COLOR MAPPING
  // ---------------------------------------------------------------------------

  Color _actionColor(String action) {
    switch (action.toLowerCase()) {
      case 'created':
      case 'uploading':
        return Colors.blue;

      case 'updated':
      case 'changing':
        return Colors.green;

      case 'deleted':
      case 'deleting':
        return Colors.red;

      case 'approved':
        return Colors.teal;

      case 'rejected':
        return Colors.orange;

      default:
        return RSColors.darkGrey;
    }
  }
}
