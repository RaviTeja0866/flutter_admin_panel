import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/tag/tag_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/tag_model.dart';

import '../../../../data/abstract/base_data_table_controlller.dart';

class TagController extends RSBaseController<TagModel> {
  static TagController get instance => Get.find();

  final _tagRepository = Get.put(TagRepository());

  @override
  bool containsSearchQuery(TagModel item, String query) {
    print('Searching for query: $query in item: ${item.name}');
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(TagModel item) async {
    try {
      print('Attempting to delete item with ID: ${item.id}');
      await _tagRepository.deleteTag(item.id);
      print('Item with ID: ${item.id} deleted successfully');
    } catch (e) {
      print('Error occurred while deleting item: $e');
    }
  }

  @override
  Future<List<TagModel>> fetchItems() async {
    try {
      print('Fetching all tags...');
      final tags = await _tagRepository.getAllTags();
      print('Fetched ${tags.length} tags');
      return tags;
    } catch (e) {
      print('Error occurred while fetching tags: $e');
      return [];
    }
  }

  // Sorting related by name
  void sortByName(int sortColumnIndex, bool ascending) {
    print('Sorting tags by name, ascending: $ascending');
    sortByProperty(sortColumnIndex, ascending, (TagModel tag) => tag.name.toLowerCase());
  }
}
