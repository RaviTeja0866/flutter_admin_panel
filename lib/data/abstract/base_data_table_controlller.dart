import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/loaders.dart';

abstract class RSBaseController<RS> extends GetxController {
  RxBool isLoading = true.obs;
  RxInt sortColumnIndex  = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<RS> allItems = <RS>[].obs;
  RxList<RS> filteredItems = <RS>[].obs;
  RxList<bool> selectedRows = <bool>[].obs;
  final searchController = TextEditingController();


  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  // Abstract Method to be implemented by subclasses for fetching items
  Future <List<RS>> fetchItems();

  // Abstract Method to be implemented by subclasses for deleting items
  Future <void> deleteItem(RS item);

  // Abstract Method to be implemented by subclasses for checking if am item contains that query
  bool containsSearchQuery(RS item, String query);

  // Common method for fetching data
  Future <void> fetchData() async{
    try{
      isLoading.value = true;
      List<RS> fetchedItems = [];
      if(allItems.isEmpty){
        fetchedItems = await fetchItems(); // Fetch items to be implemented in subclasses
      }
      allItems.assignAll(fetchedItems);
      filteredItems.assignAll(allItems);
      selectedRows.assignAll(List.generate(allItems.length, (_) => false));

      isLoading.value = false;
    } catch(e) {
      isLoading.value = false;
      RSLoaders.error(message: e.toString());
    }
  }

  // Common method for searching based on query
  void searchQuery(String query) {
    filteredItems.assignAll(
        allItems.where((item) => containsSearchQuery(item, query)),
    );
  }

  // Common method for sorting items by a property
  void sortByProperty(int columnIndex, bool ascending, Function(RS) property) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;
    filteredItems.sort((r, s) {
      if (ascending) {
        return property(r).compareTo(property(s));
      } else {
        return property(s).compareTo(property(r));
      }
    });
  }

  /// Method for adding an item to the Lists.
  void addItemToLists(RS item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false)); // Initialize selected rows
  }

  // Method for updating an item from the lists.
  void updateItemFromLists(RS item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if(itemIndex != -1) allItems[itemIndex] = item;
    if(filteredItemIndex != -1) filteredItems[itemIndex] = item;

  }

  // Method for removing on item from the lists.
  void removeItemFromLists(RS item){
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(allItems.length, (index) => false)); // Initialize the rows
  }

  // Common method for confirming deletion and performing the deletion.
  confirmAndDeleteItem(RS item) {
    // show a confirmation Dialog
    Get.defaultDialog(
        title: 'Delete Item',
        content: Text('Are You Sure you want to delete this Item'),
        confirm: SizedBox(
          width: 90,
          child: ElevatedButton(onPressed: () async => await deleteOnConfirm(item),
              style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: RSSizes.buttonHeight / 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RSSizes.buttonRadius * 5)),
              ),
              child: Text('Delete')),
        ),
        cancel: SizedBox(
          width: 90,
          child: OutlinedButton(onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: RSSizes.buttonHeight / 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(RSSizes.buttonRadius * 5)),
              ),
              child: Text('Cancel')),
        )
    );
  }

  // Method to be implemented by subclasses for handling  confirmation before deleting an item.
  deleteOnConfirm(RS item) async {
    try{

      // Remove the confirmation Dialog
      RSFullScreenLoader.stopLoading();

      // Start the Loader
      RSFullScreenLoader.popUpCircular();

      // Delete Firestore Data
      await deleteItem(item);

      removeItemFromLists(item);

      RSFullScreenLoader.stopLoading();
      RSLoaders.error(message: 'Your item has Been Deleted');
    } catch(e){
      RSFullScreenLoader.stopLoading();
      RSLoaders.error(message: e.toString());
    }

  }

}