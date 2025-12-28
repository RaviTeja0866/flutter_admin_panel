import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';

class CategoryRows extends DataTableSource {
  final controller = CategoryController.instance;
  @override
  DataRow? getRow(int index) {
    if (index >= controller.filteredItems.length) {
      return null;
    }
    final category = controller.filteredItems[index];
    final parentCategory = controller.allItems.firstWhereOrNull(
          (item) => item.id == category.parentId,
    );
   return DataRow2(
     selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
       DataCell(
           Row(
             children: [
               RSRoundedImage(
                 width: 50,
                 height: 50,
                 padding: RSSizes.sm,
                 image: category.image,
                 imageType: ImageType.network,
                 borderRadius: RSSizes.borderRadiusMd,
                 backgroundColor: RSColors.primaryBackground,
               ),
               SizedBox(width: RSSizes.spaceBtwItems),
               Expanded(child: Text(
                 category.name,
                 style: Theme.of(Get.context!).textTheme.bodyLarge!.apply(color: RSColors.primary),
                 maxLines: 2,
                 overflow: TextOverflow.ellipsis,
               ))
             ],
           )
       ),
        DataCell(Text(parentCategory !=null  ? parentCategory.name : '')),
        DataCell(category.isFeatured ? Icon(Iconsax.heart5, color: RSColors.primary) : Icon(Iconsax.heart)),
        DataCell(
          Text(
              category.updatedAt != null
                  ? DateFormat('yyyy-MM-dd hh:mm:ss a').format(category.updatedAt!)
                  : (category.createdAt != null ? DateFormat('yyyy-MM-dd hh:mm:ss a').format(category.createdAt!) : '')
          ),
        ),
        DataCell(
          RSTableActionButtons(
            onEditPressed: () =>Get.toNamed(RSRoutes.editCategory, arguments: category),
            onDeletePressed: () => controller.confirmAndDeleteItem(category),
          )
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override

  int get rowCount => controller.filteredItems.length;

  @override
  int get selectedRowCount => 0;

}
