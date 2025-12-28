import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/sizes.dart';

class CustomerRows extends DataTableSource{
  final controller = OrderController.instance;

  @override
  DataRow? getRow(int index) {
    final order = controller.filteredItems[index];
    return DataRow2(
        onTap: () => Get.toNamed(RSRoutes.orderDetails, arguments: order),
        selected: controller.selectedRows[index],
        onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
        cells: [
      DataCell(
        Text(
          order.id, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: RSColors.primary),
        ),
      ),
      DataCell(Text(order.formattedOrderDate)),
      DataCell(Text('5 Items')),
      DataCell(RSRoundedContainer(
        radius: RSSizes.cardRadiusSm,
        padding: EdgeInsets.symmetric(vertical: RSSizes.xs, horizontal: RSSizes.md),
        backgroundColor: RSHelperFunctions.getOrderStatusColor(order.status).withOpacity(0.1),
        child: Text(
          order.status.name.capitalize.toString(),
          style: TextStyle(color: RSHelperFunctions.getOrderStatusColor(order.status)),
        ),
      )),
      DataCell(Text('₹${order.totalAmount}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) => selected).length;
}

