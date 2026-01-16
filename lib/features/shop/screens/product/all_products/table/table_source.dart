import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/product/product_controller.dart';
import '../../../../../../common/widgets/data_table/table_action_buttons.dart';
import '../../../../../../common/widgets/images/rs_rounded_image.dart';
import '../../../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class ProductRows extends DataTableSource {
  final controller = Get.put(ProductController());

  @override
  DataRow? getRow(int index) {
    final product = controller.filteredItems[index];
    return DataRow2(
      selected: controller.selectedRows[index],
      onTap: () => Get.offNamed(
        '/editProduct/${product.id}',
      ),
      onSelectChanged: (value) =>
          controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Row(
          children: [
            RSRoundedImage(
              width: 50,
              height: 50,
              padding: RSSizes.xs,
              image: product.thumbnail,
              imageType: ImageType.network,
              borderRadius: RSSizes.borderRadiusMd,
              backgroundColor: RSColors.primaryBackground,
            ),
            SizedBox(width: RSSizes.spaceBtwItems),
            Flexible(
              child: Text(
                product.title,
                style: Theme.of(Get.context!)
                    .textTheme
                    .bodyLarge!
                    .apply(color: RSColors.primary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )),
        DataCell(Text(controller.getProductStockTotal(product))), // Stock
        DataCell(Text(controller.getProductSoldQuantity(product))), // Stock
        DataCell(Row(
          children: [
            RSRoundedImage(
              width: 35,
              height: 35,
              padding: RSSizes.xs,
              image: product.brand != null
                  ? product.brand!.image
                  : RSImages.defaultImage,
              imageType:
                  product.brand != null ? ImageType.network : ImageType.asset,
              borderRadius: RSSizes.borderRadiusMd,
              backgroundColor: RSColors.primaryBackground,
            ),
            SizedBox(width: RSSizes.spaceBtwItems),
            Flexible(
              child: Text(
                product.brand != null ? product.brand!.name : '',
                style: Theme.of(Get.context!)
                    .textTheme
                    .bodyLarge!
                    .apply(color: RSColors.primary),
              ),
            ),
          ],
        )), // Brand
        DataCell(Text('₹${controller.getProductPrice(product)}')), // Price
        DataCell(Text(product.formatedDate)), // Date
        DataCell(RSTableActionButtons(
          onEditPressed: () => Get.offNamed(
            '/editProduct/${product.id}',
          ),
          onDeletePressed: () {
            ActionGuard.run(
              permission: Permission.productDelete, // use correct enum
              showDeniedScreen: true,
              action: () async {
                controller.confirmAndDeleteItem(product);
              },
            );
          },
        )), // Actions
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
