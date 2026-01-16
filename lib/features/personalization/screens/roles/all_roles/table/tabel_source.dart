import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/formatters/formatter.dart';
import '../../../../controllers/roles/role_controller.dart';
import '../../../../models/role_model.dart';

class RolesRows extends DataTableSource {
  final controller = RolesController.instance;

  @override
  DataRow? getRow(int index) {
    final RoleModel role = controller.filteredItems[index];

    return DataRow2(
      onTap: () => Get.toNamed(
        RSRoutes.editRole,
        arguments: role,
        parameters: {'roleId': role.id},
      ),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
      controller.selectedRows[index] = value ?? false,
      cells: [
        /// ROLE NAME
        DataCell(
          Text(
            role.name,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyMedium
                ?.copyWith(color: RSColors.primary),
          ),
        ),

        /// DESCRIPTION
        DataCell(
          Text(
            role.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        /// PERMISSIONS COUNT
        DataCell(
          Text('${role.permissions.length}'),
        ),

        /// CREATED AT
        DataCell(
          Text(RSFormatter.formatDate(role.createdAt)),
        ),

        /// ACTIONS
        DataCell(
          RSTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(
              RSRoutes.editRole,
              arguments: role,
            ),
            onDeletePressed: role.isSystemRole
                ? null // system roles cannot be deleted
                : () {
              ActionGuard.run(
                permission: Permission.roleDelete,
                showDeniedScreen: true,
                action: () async {
                  controller.confirmAndDeleteItem(role);
                },
              );
            },
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
      controller.selectedRows.where((e) => e).length;
}
