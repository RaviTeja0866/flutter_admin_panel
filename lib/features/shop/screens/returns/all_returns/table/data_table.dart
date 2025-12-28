import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/all_returns/table/table_source.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';
import '../../../../controllers/returns/returns_controller.dart';

class ReturnsTable extends StatelessWidget {
  const ReturnsTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReturnController());

    return Obx(() {
      // Force reactive rebuild when counts change
      controller.filteredItems.length;
      controller.selectedRows.length;

      return RSPaginatedDataTable(
        minWidth: 700,
        sortAscending: controller.sortAscending.value,
        sortColumnIndex: controller.sortColumnIndex.value,

        columns: [
          DataColumn2(label: Text('Return ID')),
          DataColumn2(
            label: Text('Requested Date'),
            onSort: (columnIndex, ascending) =>
                controller.sortByDate(columnIndex, ascending),
          ),
          DataColumn2(label: Text('Item')),
          DataColumn2(
            label: Text('Status'),
            fixedWidth:
            RSDeviceUtils.isMobileScreen(context) ? 120 : null,
          ),
          DataColumn2(label: Text('Price')),
          DataColumn2(label: Text('Action'), fixedWidth: 100),
        ],

        source: ReturnRows(),
      );
    });
  }
}
