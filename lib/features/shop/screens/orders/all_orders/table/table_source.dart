import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/table_action_buttons.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class OrderRows extends DataTableSource {
  final controller = OrderController.instance;

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredItems[index];

    return DataRow2(
      // ✅ USE docId
      onTap: () {
        if (order.docId.isEmpty) {
          debugPrint('❌ docId is empty');
          return;
        }

        Get.toNamed(
          '/orders-details/${order.docId}',
        );
      },

      selected: controller.selectedRows[index],
      onSelectChanged: (value) =>
      controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(
          Text(
            order.id, // 👈 still show order number in UI
            style: Theme.of(Get.context!)
                .textTheme
                .bodyLarge!
                .apply(color: RSColors.primary),
          ),
        ),
        DataCell(Text(order.formattedOrderDate)),
        DataCell(Text('${order.items.length} Items')),
        DataCell(
          RSRoundedContainer(
            radius: RSSizes.cardRadiusSm,
            padding: EdgeInsets.symmetric(
              vertical: RSSizes.sm,
              horizontal: RSSizes.md,
            ),
            backgroundColor:
            RSHelperFunctions.getOrderStatusColor(order.status)
                .withOpacity(0.1),
            child: Text(
              order.status.name.capitalize!,
              style: TextStyle(
                color:
                RSHelperFunctions.getOrderStatusColor(order.status),
              ),
            ),
          ),
        ),
        DataCell(Text('₹${order.totalAmount}')),
        DataCell(
          RSTableActionButtons(
            view: true,
            edit: false,
            onViewPressed: () => Get.toNamed(
              '${RSRoutes.orderDetails}/${order.docId}', // ✅ FIXED
            ),
            onDeletePressed: () {
              ActionGuard.run(
                permission: Permission.orderDelete, // use correct enum
                showDeniedScreen: true,
                action: () async {
                  controller.confirmAndDeleteItem(order);
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

