import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:roguestore_admin_panel/features/shop/models/order_model.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  // Firebase Firestore Instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all Orders from the 'Orders' collection
  Future<List<OrderModel>> getAllOrders() async {
    print("📥 [OrderRepository] Fetching all orders...");

    try {
      print("➡️ Query: Orders ordered by orderDate DESC");

      final result = await _db
          .collection('Orders')
          .orderBy('orderDate', descending: true)
          .get();

      print("📦 [Firestore] Total documents fetched: ${result.docs.length}");

      List<OrderModel> orders = [];

      for (var doc in result.docs) {
        print("----------------------------------------------------");
        print("📄 Document ID: ${doc.id}");
        print("🆔 Order ID: ${doc.data()['id']}");
        print("📅 orderDate raw value: ${doc.data()['orderDate']}");
        print("🔧 Type of orderDate: ${doc.data()['orderDate']?.runtimeType}");
        print("📅 updatedAt raw value: ${doc.data()['updatedAt']}");
        print("🔧 Type of updatedAt: ${doc.data()['updatedAt']?.runtimeType}");
        print("----------------------------------------------------");

        try {
          final order = OrderModel.fromSnapshot(doc);
          orders.add(order);
          print("✅ Parsed OrderModel successfully: ${order.id}");
        } catch (e) {
          print("❌ ERROR parsing OrderModel for doc ${doc.id}: $e");
          print("⚠️ SKIPPING document due to parsing failure.");
        }
      }

      print("🎉 [OrderRepository] Successfully loaded ${orders.length} orders");
      return orders;

    } on FirebaseException catch (e) {
      print("❌ FirebaseException: ${e.code} - ${e.message}");
      throw RSFirebaseException(e.code).message;

    } on PlatformException catch (e) {
      print("❌ PlatformException: ${e.code} - ${e.message}");
      throw RSPlatformException(e.code).message;

    } catch (e) {
      print("❌ Unknown Error: $e");
      throw 'Something went wrong. Please try again';
    }
  }

  // Create a new Order document in the 'Orders' collection
  Future<void> addOrder(OrderModel order) async {
    try {
      await _db.collection('Orders').add(order.toJson());
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _db.collection('Orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromSnapshot(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update Specific value of an order
  Future<void> updateOrderSpecificValue(String orderId, Map<String, dynamic> data) async {
    try {
      await _db.collection('Orders').doc(orderId).update(data);
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete an existing Order from the 'Orders' collection
  Future<void> deleteOrder(String orderId) async {
    try {
      await _db.collection('Orders').doc(orderId).delete();
    } on FirebaseException catch (e) {
      throw RSFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw RSPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<Map<String, dynamic>> createJuspayRefund({
    required String orderId,
    required String uniqueRequestId,
    required String amount,
    String? routingId, // Optional: but required if your backend expects it
  }) async {
    print('[JUSPAY] Creating refund for order: $orderId, Amount: $amount');

    final url = Uri.parse('https://admin.api.roguestore.in/refundOrder');

    // Build request payload
    final requestBody = {
      'order_id': orderId,
      'unique_request_id': uniqueRequestId,
      'amount': amount,
    };

    // Add optional routing ID
    if (routingId != null) {
      requestBody['routing_id'] = routingId;
    }

    print('[JUSPAY] Refund Request Body: ${jsonEncode(requestBody)}');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('[JUSPAY] Refund Status Code: ${response.statusCode}');
      print('[JUSPAY] Refund Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          print('[JUSPAY] Refund successful');
          return jsonResponse['data'];
        } else {
          throw Exception('Refund failed: ${jsonResponse['error'] ?? "Unknown error"}');
        }
      } else {
        throw Exception('Refund request failed: ${response.body}');
      }
    } catch (e) {
      print('[JUSPAY] Refund exception: $e');
      throw Exception('Refund process failed: $e');
    }
  }

}
