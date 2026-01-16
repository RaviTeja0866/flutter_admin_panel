import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/category/category_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/category_model.dart';

import '../../../../data/abstract/base_data_table_controlller.dart';


class CategoryController extends RSBaseController<CategoryModel> {
  static CategoryController get instance => Get.find();


  final _categoryRepository = CategoryRepository.instance;


  @override
  bool containsSearchQuery(CategoryModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(CategoryModel item) async{
    await _categoryRepository.deleteCategory(item.id);
  }

  @override
  Future<List<CategoryModel>> fetchItems() async{
   return await _categoryRepository.getAllCategories();
  }

  // sorting related name
 void sortByName(int sortColumnIndex, bool ascending){
    sortByProperty(sortColumnIndex,  ascending, (CategoryModel category) => category.name.toLowerCase());
 }
}
