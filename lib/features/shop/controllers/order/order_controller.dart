import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/order/order_repository.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/popups/loaders.dart';

import '../../../../data/abstract/base_data_table_controlller.dart';
import '../../models/order_model.dart';

class OrderController extends RSBaseController<OrderModel> {
  static OrderController get instance => Get.find();

  RxBool statusLoader = false.obs;
  var orderStatus = OrderStatus.delivered.obs;
  final _orderRepository = OrderRepository.instance;


  @override
  Future<List<OrderModel>> fetchItems() async {
    try {
      isLoading.value = true; // Start loading
      sortAscending.value = false;
      final items = await _orderRepository.getAllOrders();
      return items;
    } catch (e) {
      RSLoaders.warning(message: 'Failed to load orders. Please try again.');
      rethrow;
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  @override
  bool containsSearchQuery(item, String query) {
    final result = item.id.toLowerCase().contains(query.toLowerCase());
    return result;
  }

  @override
  Future<void> deleteItem(OrderModel item) async {
    try {
      await _orderRepository.deleteOrder(item.docId);
    } catch (e) {
      rethrow;
    }
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (OrderModel o) => o.totalAmount.toString().toLowerCase());
  }

  void sortByDate(int sortColumnIndex, bool ascending) {
    sortByProperty(
        sortColumnIndex, ascending, (OrderModel o) => o.orderDate.toString().toLowerCase());
  }

  Future<void> updateOrderStatus(OrderModel order, OrderStatus newStatus) async {
    try {
      statusLoader.value = true;

      // Update local model (SAFE)
      order.status = newStatus;

      // Persist to Firestore
      await _orderRepository.updateOrderSpecificValue(
        order.docId,
        {'status': newStatus.name}, // "delivered", "shipped"
      );

      // Refresh table lists
      updateItemFromLists(order);

      RSLoaders.success(
        message: 'Order Status Updated',
      );
    } catch (e) {
      RSLoaders.warning(
        message: e.toString(),
      );
    } finally {
      statusLoader.value = false;
    }
  }
}
