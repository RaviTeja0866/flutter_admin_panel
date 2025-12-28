import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/order/order_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/all_orders/table/table_source.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';

class OrderTable extends StatelessWidget {
  const OrderTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    return Obx(
      () {
        Text(controller.filteredItems.length.toString());
        Text(controller.selectedRows.length.toString());

        //Table
        return RSPaginatedDataTable(
        minWidth: 700,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,
        columns: [
          DataColumn2(label: Text('Order ID')),
          DataColumn2(label: Text('Date'), onSort: (columnIndex, ascending) => controller.sortByDate(columnIndex, ascending)),
          DataColumn2(label: Text('Items')),
          DataColumn2(label: Text('Status'), fixedWidth: RSDeviceUtils.isMobileScreen(context) ? 120 : null),
          DataColumn2(label: Text('Amount')),
          DataColumn2(label: Text('Action'),  fixedWidth: 100),
        ],
        source: OrderRows(),
      ); },
    );
  }
}
