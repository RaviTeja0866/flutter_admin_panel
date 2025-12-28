import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/helpers/helper_functions.dart';

import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/customer/customer_detail_controller.dart';

class CustomerOrdersRows extends DataTableSource{
  final controller = CustomerDetailController.instance;
  @override
  DataRow? getRow(int index) {
    final order = controller.filteredCustomerOrders[index];
    final totalAmount = order.items.fold<double>(0, (previousValue, element) => previousValue + element.price);
    return DataRow2(
        selected: controller.selectedRows[index],
        onTap: () => Get.toNamed(RSRoutes.orderDetails, arguments: order),
        cells: [
          DataCell(Text(order.id, style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: RSColors.primary))),
          DataCell(Text(order.formattedOrderDate)),
          DataCell(Text('${order.items.length} Items')),
          DataCell(
              RSRoundedContainer(
                radius: RSSizes.cardRadiusSm,
                padding: EdgeInsets.symmetric(vertical: RSSizes.sm, horizontal: RSSizes.md),
                backgroundColor: RSHelperFunctions.getOrderStatusColor(order.status).withOpacity(0.1),
                child: Text(
                  order.status.name.capitalize.toString(),
                  style: TextStyle(color: RSHelperFunctions.getOrderStatusColor(order.status)),
                ),
              )),
          DataCell(Text('₹$totalAmount')),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredCustomerOrders.length;

  @override
  int get selectedRowCount => controller.selectedRows.where((selected) =>selected).length;

}