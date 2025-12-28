import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/shop_category/shop_category_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/shop_category.dart';

import '../../../../data/abstract/base_data_table_controlller.dart';

class ShopCategoryController extends RSBaseController<ShopCategory> {
  static ShopCategoryController get instance => Get.find();

  final _shopCategoryRepository = Get.put(ShopCategoryRepository());

  @override
  Future<void> deleteItem(ShopCategory item) async {
    await _shopCategoryRepository.deleteShopCategory(item.id ?? '');
  }

  @override
  Future<List<ShopCategory>> fetchItems() async {
    return await _shopCategoryRepository.getAllShopCategories();
  }


  @override
  bool containsSearchQuery(ShopCategory item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  // Additional helper method for formatting category names (if needed)
  String formatCategoryName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }
}
