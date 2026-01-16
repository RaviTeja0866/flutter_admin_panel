import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/features/personalization/models/admin_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';

import '../../../../data/repositories/user/addresses_repository.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/user_model.dart';

class CustomerDetailController extends GetxController {
  static CustomerDetailController get instance => Get.find();

  RxBool ordersLoading = true.obs;
  RxBool addressesLoading = true.obs;
  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;
  RxList<bool> selectedRows = <bool>[].obs;

  Rx<UserModel> customer = UserModel.empty().obs;

  final addressRepository = Get.put(AddressRepository());
  final searchTextController = TextEditingController();

  RxList<OrderModel> allCustomerOrders = <OrderModel>[].obs;
  RxList<OrderModel> filteredCustomerOrders = <OrderModel>[].obs;

  Future<void> getCustomerOrders() async {
    try {
      ordersLoading.value = true;

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        customer.value.orders =
        await UserRepository.instance.fetchUserOrders(customer.value.id!);
      }

      allCustomerOrders.assignAll(customer.value.orders);
      filteredCustomerOrders.assignAll(customer.value.orders);
      selectedRows.assignAll(
        List.generate(customer.value.orders.length, (_) => false),
      );
    } catch (e) {
      RSLoaders.error(message: e.toString());
    } finally {
      ordersLoading.value = false;
    }
  }

  Future<void> getCustomerAddresses() async {
    try {
      addressesLoading.value = true;

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        customer.value.addresses =
        await addressRepository.fetchUserAddresses(customer.value.id!);
      }
    } catch (e) {
      RSLoaders.error(message: e.toString());
    } finally {
      addressesLoading.value = false;
    }
  }

  void searchQuery(String query) {
    final q = query.toLowerCase();

    filteredCustomerOrders.assignAll(
      allCustomerOrders.where((order) {
        final orderId = order.id ?? '';
        final dateStr = order.orderDate.toString();

        return orderId.toLowerCase().contains(q) ||
            dateStr.contains(q);
      }).toList(),
    );
  }

  void sortById(int columnIndex, bool ascending) {
    sortAscending.value = ascending;

    filteredCustomerOrders.sort((a, b) {
      final aId = a.id ?? '';
      final bId = b.id ?? '';

      return ascending
          ? aId.compareTo(bId)
          : bId.compareTo(aId);
    });

    sortColumnIndex.value = columnIndex;
  }
}
