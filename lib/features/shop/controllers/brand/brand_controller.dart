import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/brand/brand_repository.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/category/category_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/brand_model.dart';

import '../../../../data/abstract/base_data_table_controlller.dart';

class BrandController extends RSBaseController<BrandModel> {
  static BrandController get instance => Get.find();

  final _brandRepository = Get.put(BrandRepository());
  final categoryController = Get.put(CategoryController());

  @override
  Future<List<BrandModel>> fetchItems() async {
    try {
      final fetchedBrands = await _brandRepository.getAllBrands();

      final fetchedBrandCategories = await _brandRepository.getAllBrandCategories();

      // Fetch all categories if data does not already exist
      if (categoryController.allItems.isEmpty) {
        await categoryController.fetchItems();
      }

      // Loop all brands and fetch categories of each
      for (var brand in fetchedBrands) {

        // Extract Category Ids from the documents
        List<String> categoryIds = fetchedBrandCategories
            .where((brandCategory) => brandCategory.brandId == brand.id)
            .map((brandCategory) => brandCategory.categoryId)
            .toList();


        brand.brandCategories = categoryController.allItems
            .where((category) => categoryIds.contains(category.id))
            .toList();

      }

      return fetchedBrands;
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool containsSearchQuery(BrandModel item, String query) {
    final result = item.name.toLowerCase().contains(query.toLowerCase());
    return result;
  }

  @override
  Future<void> deleteItem(BrandModel item) async {
    try {
      await _brandRepository.deleteBrand(item);
    } catch (e) {
      rethrow;
    }
  }

  // Sorting related by name
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(
      sortColumnIndex,
      ascending,
          (BrandModel brand) => brand.name.toLowerCase(),
    );
  }

}
