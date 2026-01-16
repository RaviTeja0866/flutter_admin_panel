import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/table_action_buttons.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/returns/returns_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class ReturnRows extends DataTableSource {
  final controller = ReturnController.instance;

  @override
  DataRow getRow(int index) {
    final item = controller.filteredItems[index];

    return DataRow2(
      onTap: () => Get.toNamed(
        '${RSRoutes.returnsDetails}/${item.id}',
        arguments: item,
      ),
      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
      controller.selectedRows[index] = value ?? false,
      cells: [

        // 1. Return Order ID
        DataCell(
          Text(
            item.id!,
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .copyWith(color: RSColors.primary),
          ),
        ),

        // 2. Date
        DataCell(
          Text(item.formattedOrderDate),
        ),

        // 3. Items (always 1 return item or qty)
        DataCell(
          Text("${item.quantity} Item(s)"),
        ),

        // 4. Return Status
        DataCell(
          RSRoundedContainer(
            radius: RSSizes.cardRadiusSm,
            padding: const EdgeInsets.symmetric(
              vertical: RSSizes.sm,
              horizontal: RSSizes.md,
            ),
            backgroundColor:
            RSHelperFunctions.getReturnStatusColor(item.status)
                .withOpacity(0.1),
            child: Text(
              item.status.name.capitalize!,
              style: TextStyle(
                color: RSHelperFunctions.getReturnStatusColor(item.status),
              ),
            ),
          ),
        ),

        // 5. Amount
        DataCell(
          Text("₹${item.productPrice.toStringAsFixed(0)}"),
        ),

        // 6. Action buttons
        DataCell(
          RSTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(
              '${RSRoutes.returns}/${item.id}',
              arguments: item,
            ),
            onDeletePressed: () {
              ActionGuard.run(
                permission: Permission.returnDelete, // use correct enum
                showDeniedScreen: true,
                action: () async {
                  controller.confirmAndDeleteItem(item);
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
      controller.selectedRows.where((x) => x == true).length;
}

