import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/models/address_model.dart';
import 'cart_model.dart';


class OrderModel {
  final String id;
  final String docId;
  final String userId;
  final String email;
  OrderStatus status;
  double totalAmount;
  final String? paymentMethod;
  final double? shippingCost;
  final double? taxCost;
  final DateTime orderDate;
  String paymentStatus;
  final AddressModel? shippingAddress;
  final AddressModel? billingAddress;
  final DateTime? deliveryDate;
  final String? juspayOrderId;
  List<CartItemModel> items;
  final bool billingAddressSameShipping;

  OrderModel({
    required this.id,
    required this.email,
    this.userId = '',
    this.docId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxCost,
    required this.orderDate,
    this.paymentStatus = 'Pending',
    this.paymentMethod,
    this.shippingAddress,
    this.billingAddress,
    this.deliveryDate,
    this.juspayOrderId,
    this.billingAddressSameShipping = true,
  });

  String get formattedOrderDate =>
      RSHelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null
      ? RSHelperFunctions.getFormattedDate(deliveryDate!)
      : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
      ? 'Shipment On the Way'
      : 'Processing';

  static DateTime? _safeDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  // Static function to create any empty order model
  static OrderModel empty() => OrderModel(
    id: '',
    email: '',
    items: [],
    orderDate: DateTime.now(),
    status: OrderStatus.pending,
    paymentMethod: null,
    totalAmount: 0,
    shippingCost: 0,
    taxCost: 0,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userId': userId,
      'status': status.toString(),
      //Enum to String
      'totalAmount': totalAmount,
      'shippingCost': shippingCost,
      'taxCost': taxCost,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'shippingAddress': shippingAddress?.toJson(),
      'billingAddress': billingAddress?.toJson(),
      //Convert addressModel to map
      'deliveryDate': deliveryDate,
      'juspayOrderId': juspayOrderId,
      'items': items.map((item) => item.toJson()).toList(),
      // convert cartItemModel to map
    };
  }

  static OrderStatus _parseOrderStatus(dynamic raw) {
    if (raw == null) return OrderStatus.pending;

    final value = raw.toString().toLowerCase();

    return OrderStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == value ||
          "orderstatus.${e.name}".toLowerCase() == value,
      orElse: () => OrderStatus.pending,
    );
  }
  
  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};

    return OrderModel(
      docId: snapshot.id,
      id: data['id']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      email: data['email']?.toString() ?? '',

      status: _parseOrderStatus(data['status']),

      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      shippingCost: (data['shippingCost'] ?? 0).toDouble(),
      taxCost: (data['taxCost'] ?? 0).toDouble(),

      orderDate: _safeDate(data['orderDate']) ?? DateTime.now(),

      paymentMethod: data['paymentMethod']?.toString(),
      paymentStatus: data['paymentStatus']?.toString() ?? 'Pending',

      billingAddress: data['billingAddress'] != null
          ? AddressModel.fromMap(data['billingAddress'])
          : AddressModel.empty(),

      shippingAddress: data['shippingAddress'] != null
          ? AddressModel.fromMap(data['shippingAddress'])
          : AddressModel.empty(),

      deliveryDate: _safeDate(data['deliveryDate']),
      juspayOrderId: data['juspayOrderId']?.toString(),

      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

}
