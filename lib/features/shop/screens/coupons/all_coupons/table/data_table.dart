import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/all_coupons/table/table_source.dart';

import '../../../../../../common/widgets/data_table/paginated_data_table.dart';

class CouponTable extends StatelessWidget {
  const CouponTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponController());
    return Obx(
          () {
        // You can log these values or use them in your UI if needed
        Text(controller.filteredItems.length.toString());
        Text(controller.selectedRows.length.toString());

        // Pass controller.filteredItems to CouponRows constructor
        return RSPaginatedDataTable(
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          minWidth: 900,
          columns: [
            DataColumn2(
              label: Text('Code'),
              onSort: (columnIndex, ascending) =>
                  controller.sortByCode(columnIndex, ascending),
            ),
            DataColumn2(
              label: Text('Discount'),
              onSort: (columnIndex, ascending) =>
                  controller.sortByDiscount(columnIndex, ascending),
            ),
            DataColumn2(
              label: Text('Max Uses'),
            ),
            DataColumn2(
              label: Text('Status'),
            ),
            DataColumn2(
              label: Text('Start Date'),
              onSort: (columnIndex, ascending) =>
                  controller.sortByStartDate(columnIndex, ascending),
            ),
            DataColumn2(
              label: Text('End Date'),
              onSort: (columnIndex, ascending) =>
                  controller.sortByEndDate(columnIndex, ascending),
            ),
            DataColumn2(
              label: Text('Action'),
              fixedWidth: 100,
            ),
          ],
          source: CouponRows(),  // Pass filteredItems here
        );
      },
    );
  }
}
