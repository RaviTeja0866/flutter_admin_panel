import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/formatters/formatter.dart';
import '../../../../controllers/adminroles_controller.dart';
import '../../../../models/admin_model.dart';


class AdminUsersRows extends DataTableSource {
  final controller = AdminUsersController.instance;

  @override
  DataRow? getRow(int index) {
    final AdminUserModel user = controller.filteredItems[index];

    return DataRow2(
      onTap: () => Get.toNamed(
        RSRoutes.rolesAndPermissions,
        arguments: user,
        parameters: {'adminId': user.roleId},
      ),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
      controller.selectedRows[index] = value ?? false,
      cells: [
        /// USER
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: RSColors.primary.withOpacity(0.1),
                child: Text(
                  user.firstName.isNotEmpty
                      ? user.firstName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: RSSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.fullName,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: RSColors.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.email,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: RSColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// ROLE
        DataCell(Text(user.roleId)),

        /// STATUS
        DataCell(
          Text(
            user.isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: user.isActive ? Colors.green : Colors.red,
            ),
          ),
        ),

        /// LAST LOGIN
        DataCell(
          Text(
            user.lastLoginAt != null
                ? RSFormatter.formatDate(user.lastLoginAt!)
                : '—',
          ),
        ),

        /// CREATED AT
        DataCell(Text(user.formattedCreatedAt)),

        /// ACTIONS
        DataCell(
          RSTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(
              RSRoutes.rolesAndPermissions,
              arguments: user,
            ),
            onDeletePressed: () {
              ActionGuard.run(
                permission: Permission.adminDelete,
                showDeniedScreen: true,
                action: () async {
                  controller.confirmAndDeleteItem(user);
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
      controller.selectedRows.where((selected) => selected).length;
}
