import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/product/all_products/table/table_source.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

class ProductTable extends StatelessWidget {
  const ProductTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =  Get.put(ProductController());
    return Obx(
      (){
        //Products & Selected Rows are hidden => just update the ui => Obx =>[ProductRows]
        Text(controller.filteredItems.length.toString());
        Text(controller.selectedRows.length.toString());

        return RSPaginatedDataTable(
        minWidth: 1000,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(
                label: Text('Product'),
                fixedWidth: !RSDeviceUtils.isDesktopScreen(context) ? 300 : 400,
                onSort: (columnIndex,ascending) => controller.sortByName(columnIndex, ascending),
            ),
            DataColumn2(label: Text('Stock'),onSort: (columnIndex,ascending) => controller.sortByName(columnIndex, ascending),
            ),
            DataColumn2(label: Text('Sold'),onSort: (columnIndex,ascending) => controller.sortByName(columnIndex, ascending)),
            DataColumn2(label: Text('Brand')),
            DataColumn2(label: Text('Price'),onSort: (columnIndex,ascending) => controller.sortByName(columnIndex, ascending)),
            DataColumn2(label: Text('Date')),
            DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: ProductRows(),
      );},
    );
  }
}
