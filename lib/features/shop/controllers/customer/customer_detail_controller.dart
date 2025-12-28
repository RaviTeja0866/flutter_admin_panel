import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/user/user_repository.dart';
import 'package:roguestore_admin_panel/features/personalization/models/user_model.dart';
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';

import '../../../../data/repositories/user/addresses_repository.dart';
import '../../../../utils/popups/loaders.dart';

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
      print("Fetching customer orders...");
      ordersLoading.value = true;

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        print("Customer ID: ${customer.value.id}");
        customer.value.orders = await UserRepository.instance.fetchUserOrders(customer.value.id!);
        print("Fetched orders: ${customer.value.orders}");
      } else {
        print("Customer ID is null or empty.");
      }

      allCustomerOrders.assignAll(customer.value.orders ?? []);
      filteredCustomerOrders.assignAll(customer.value.orders ?? []);
      selectedRows.assignAll(List.generate(customer.value.orders?.length ?? 0, (index) => false));

      print("All customer orders: $allCustomerOrders");
      print("Filtered customer orders: $filteredCustomerOrders");
    } catch (e) {
      print("Error fetching customer orders: $e");
      RSLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      ordersLoading.value = false;
      print("Finished fetching customer orders. Loading status: $ordersLoading");
    }
  }

  Future<void> getCustomerAddresses() async {
    try {
      print("Fetching customer addresses...");
      addressesLoading.value = true;

      if (customer.value.id != null && customer.value.id!.isNotEmpty) {
        print("Customer ID: ${customer.value.id}");
        customer.value.addresses = await addressRepository.fetchUserAddresses(customer.value.id!);
        print("Fetched addresses: ${customer.value.addresses}");
      } else {
        print("Customer ID is null or empty.");
      }
    } catch (e) {
      print("Error fetching customer addresses: $e");
      RSLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      addressesLoading.value = false;
      print("Finished fetching customer addresses. Loading status: $addressesLoading");
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

    update();
  }

  void sortById(int sortColumnIndex, bool ascending) {
    sortAscending.value = ascending;

    filteredCustomerOrders.sort((r, s) {
      final rId = r.id ?? '';
      final sId = s.id ?? '';

      return ascending
          ? rId.toLowerCase().compareTo(sId.toLowerCase())
          : sId.toLowerCase().compareTo(rId.toLowerCase());
    });

    this.sortColumnIndex.value = sortColumnIndex;
    update();
  }
}
