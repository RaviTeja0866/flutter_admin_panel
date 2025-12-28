import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../features/shop/models/wallet_model.dart';

class WalletRepository extends GetxController {
  static WalletRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ------------------------------------------------------------
  /// GET WALLET BALANCE (Admin View)
  /// ------------------------------------------------------------
  Future<double> fetchWalletBalance(String userId) async {
    try {
      final doc = await _db
          .collection("Users")
          .doc(userId)
          .collection("Wallet")
          .doc("Balance")
          .get();

      if (!doc.exists) return 0.0;

      return (doc["balance"] ?? 0).toDouble();
    } catch (e) {
      print("Wallet balance error: $e");
      return 0.0;
    }
  }

  /// ------------------------------------------------------------
  /// FETCH ALL TRANSACTIONS
  /// ------------------------------------------------------------
  Future<List<WalletTransactionModel>> fetchAllTransactions(
      String userId) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .orderBy("date", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => WalletTransactionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Fetch all wallet transactions error: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// PAGINATED TRANSACTIONS
  /// ------------------------------------------------------------
  Future<List<WalletTransactionModel>> fetchPaginatedTransactions({
    required String userId,
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    try {
      Query query = _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .orderBy("date", descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => WalletTransactionModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      print("Pagination error: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// FILTER: CREDIT or DEBIT
  /// ------------------------------------------------------------
  Future<List<WalletTransactionModel>> filterByType(
      String userId, bool isCredit) async {
    try {
      final snap = await _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .where("isCredit", isEqualTo: isCredit)
          .orderBy("date", descending: true)
          .get();

      return snap.docs
          .map((doc) => WalletTransactionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Filter by type error: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// FILTER: SOURCE (refund, promo, adjustment)
  /// ------------------------------------------------------------
  Future<List<WalletTransactionModel>> filterBySource(
      String userId, String source) async {
    try {
      final snap = await _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .where("source", isEqualTo: source)
          .orderBy("date", descending: true)
          .get();

      return snap.docs
          .map((doc) => WalletTransactionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Filter by source error: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// FILTER: ORDER ID (Refunds related to one order)
  /// ------------------------------------------------------------
  Future<List<WalletTransactionModel>> filterByOrderId(
      String userId, String orderId) async {
    try {
      final snap = await _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .where("orderId", isEqualTo: orderId)
          .orderBy("date", descending: true)
          .get();

      return snap.docs
          .map((doc) => WalletTransactionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Filter by order ID error: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// FILTER: EXPIRING / EXPIRED TRANSACTIONS
  /// ------------------------------------------------------------
  Future<List<WalletTransactionModel>> fetchExpired(String userId) async {
    try {
      final now = Timestamp.now();

      final snap = await _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .where("expiryDate", isLessThan: now)
          .orderBy("expiryDate", descending: true)
          .get();

      return snap.docs
          .map((doc) => WalletTransactionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Expired fetch error: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// FILTER: DATE RANGE
  /// ------------------------------------------------------------
  Future<List<WalletTransactionModel>> filterByDateRange(
      String userId,
      DateTime start,
      DateTime end,
      ) async {
    try {
      final snap = await _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where("date", isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy("date", descending: true)
          .get();

      return snap.docs
          .map((doc) => WalletTransactionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print("Date filter error: $e");
      return [];
    }
  }

  /// ------------------------------------------------------------
  /// COUNT Transactions
  /// ------------------------------------------------------------
  Future<int> getTransactionCount(String userId) async {
    try {
      final result = await _db
          .collection("Users")
          .doc(userId)
          .collection("WalletTransactions")
          .count()
          .get();

      return result.count ?? 0;
    } catch (e) {
      print("Count error: $e");
      return 0;
    }
  }
}
