
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/data_table/paginated_data_table.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/shop_category/shop_category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/all_shop_categories/table/table_source.dart';

class ShopCategoryTable extends StatelessWidget {
  const ShopCategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShopCategoryController());
    return Obx(
          () {
        Text(controller.filteredItems.length.toString());
        Text(controller.filteredItems.length.toString());

        //Table
        return RSPaginatedDataTable(
          minWidth: 700,
          tableHeight: 900,
          dataRowHeight: 110,
          sortAscending: controller.sortAscending.value,
          sortColumnIndex: controller.sortColumnIndex.value,
          columns: [
            DataColumn2(label: Text('Shop Category')),
            DataColumn2(label: Text('Title')),
            DataColumn2(label: Text('Gender')),
            DataColumn2(label: Text('Active')),
            DataColumn2(label: Text('Action'), fixedWidth: 100),
          ],
          source: ShopCategoryRows(),
        );},
    );
  }
}
