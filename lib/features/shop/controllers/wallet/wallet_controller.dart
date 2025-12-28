import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/wallet/wallet_repository.dart';

import '../../models/wallet_model.dart';


class WalletController extends GetxController {
  static WalletController get instance => Get.find();

  /// Repository
  final walletRepo = Get.put(WalletRepository());

  /// Observables
  RxBool loading = true.obs;
  RxDouble walletBalance = 0.0.obs;

  RxList<WalletTransactionModel> allTransactions = <WalletTransactionModel>[].obs;
  RxList<WalletTransactionModel> filteredTransactions = <WalletTransactionModel>[].obs;

  final searchTextController = TextEditingController();

  RxInt sortColumnIndex = 1.obs;
  RxBool sortAscending = true.obs;

  /// The userId passed from CustomerDetail page
  late String userId;

  /// Initialize Controller
  Future<void> loadWallet(String uid) async {
    userId = uid;
    loading.value = true;

    try {
      /// Load Balance
      walletBalance.value =
          await walletRepo.fetchWalletBalance(uid) ?? 0.0;

      /// Load All Transactions
      final txns = await walletRepo.fetchAllTransactions(uid);
      allTransactions.assignAll(txns);
      filteredTransactions.assignAll(txns);
    } catch (e) {
      print("Error loading wallet: $e");
    } finally {
      loading.value = false;
    }
  }

  /// SEARCH WALLET TRANSACTIONS
  void searchQuery(String query) {
    final q = query.toLowerCase();

    filteredTransactions.assignAll(
      allTransactions.where((txn) =>
      txn.title.toLowerCase().contains(q) ||
          txn.subtitle.toLowerCase().contains(q) ||
          txn.source.toLowerCase().contains(q) ||
          (txn.orderId ?? "").toLowerCase().contains(q)),
    );

    update();
  }

  /// SORT BY AMOUNT / DATE / TITLE
  void sortByColumn(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    filteredTransactions.sort((a, b) {
      int compare;

      switch (columnIndex) {
        case 0:
          compare = a.title.compareTo(b.title);
          break;
        case 1:
          compare = a.amount.compareTo(b.amount);
          break;
        case 2:
          compare = a.date.compareTo(b.date);
          break;
        default:
          compare = a.title.compareTo(b.title);
      }

      return ascending ? compare : -compare;
    });

    update();
  }

  /// FILTER BY CREDIT (True) / DEBIT (False)
  Future<void> filterByType(bool isCredit) async {
    loading.value = true;
    try {
      final txns = await walletRepo.filterByType(userId, isCredit);
      filteredTransactions.assignAll(txns);
    } catch (e) {
      print("Filter Error: $e");
    }
    loading.value = false;
  }

  /// FILTER BY SOURCE
  Future<void> filterBySource(String source) async {
    loading.value = true;
    try {
      final txns = await walletRepo.filterBySource(userId, source);
      filteredTransactions.assignAll(txns);
    } catch (e) {
      print("Filter Error: $e");
    }
    loading.value = false;
  }

  /// FILTER BY DATE RANGE
  Future<void> filterByDateRange(DateTime start, DateTime end) async {
    loading.value = true;
    try {
      final txns = await walletRepo.filterByDateRange(userId, start, end);
      filteredTransactions.assignAll(txns);
    } catch (e) {
      print("Filter Error: $e");
    }
    loading.value = false;
  }

  /// RESET FILTERS
  void resetFilters() {
    filteredTransactions.assignAll(allTransactions);
    searchTextController.clear();
    update();
  }
}
