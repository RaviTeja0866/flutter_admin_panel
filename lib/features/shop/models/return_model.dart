import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';

import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/models/address_model.dart';

class ReturnModel {
  final String? id;
  final String orderId;
  final String cartItemId;
  final String reason;
  final String additionalDetails;
  final DateTime requestDate;
  final String productTitle;
  final String productSize;
  final double productPrice;
  final int quantity;

  final List<String> imageUrls;
  final String? videoUrl;

  final AddressModel? shippingAddress;

  ReturnStatus status;
  final String userId;

  DateTime? updatedDate;
  final String? adminNotes;

  // refund fields
  String refundStatus;
  DateTime? refundProcessedAt;
  double? refundAmount;
  final String? juspayOrderId;
  final String? paymentMethod;
  final String? refundRequestId;

  // timeline fields
  DateTime? approvedAt;
  DateTime? pickupScheduledAt;
  DateTime? pickedUpAt;
  DateTime? receivedAt;
  DateTime? refundedAt;
  DateTime? completedAt;

  ReturnModel({
    this.id,
    required this.orderId,
    required this.cartItemId,
    required this.reason,
    required this.additionalDetails,
    required this.requestDate,
    required this.productTitle,
    required this.productSize,
    required this.productPrice,
    required this.quantity,
    this.imageUrls = const [],
    this.videoUrl,
    this.shippingAddress,
    required this.status,
    required this.userId,
    this.juspayOrderId,
    this.paymentMethod,
    this.refundRequestId,
    this.adminNotes,
    this.updatedDate,
    this.refundStatus = "none",
    this.refundProcessedAt,
    this.refundAmount,
    this.approvedAt,
    this.pickupScheduledAt,
    this.pickedUpAt,
    this.receivedAt,
    this.refundedAt,
    this.completedAt,
  });

  String get formattedOrderDate =>
      RSHelperFunctions.getFormattedDate(requestDate);

  static ReturnModel empty() {
    return ReturnModel(
      id: '',
      orderId: '',
      cartItemId: '',
      reason: '',
      additionalDetails: '',
      requestDate: DateTime.now(),
      productTitle: '',
      productSize: '',
      productPrice: 0.0,
      quantity: 0,
      imageUrls: const [],
      videoUrl: null,
      shippingAddress: null,
      status: ReturnStatus.pending,
      userId: '',
      updatedDate: null,
      adminNotes: null,
      refundStatus: "none",
      refundProcessedAt: null,
      refundAmount: null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'cartItemId': cartItemId,
      'reason': reason,
      'additionalDetails': additionalDetails,
      'requestDate': Timestamp.fromDate(requestDate),
      'productTitle': productTitle,
      'productSize': productSize,
      'productPrice': productPrice,
      'quantity': quantity,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'shippingAddress': shippingAddress?.toJson(),
      'status': status.name,
      'userId': userId,
      'adminNotes': adminNotes,
      'updatedDate': updatedDate != null ? Timestamp.fromDate(updatedDate!) : null,

      // refund fields
      'refundStatus': refundStatus,
      'refundProcessedAt':
      refundProcessedAt != null ? Timestamp.fromDate(refundProcessedAt!) : null,
      'refundAmount': refundAmount,
      'juspayOrderId': juspayOrderId,
      'paymentMethod': paymentMethod,
      'refundRequestId': refundRequestId,

      // timeline fields
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'pickupScheduledAt':
      pickupScheduledAt != null ? Timestamp.fromDate(pickupScheduledAt!) : null,
      'pickedUpAt': pickedUpAt != null ? Timestamp.fromDate(pickedUpAt!) : null,
      'receivedAt': receivedAt != null ? Timestamp.fromDate(receivedAt!) : null,
      'refundedAt': refundedAt != null ? Timestamp.fromDate(refundedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  factory ReturnModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    DateTime? _parse(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      return null;
    }

    return ReturnModel(
      id: snapshot.id,
      orderId: data['orderId'] ?? '',
      cartItemId: data['cartItemId'] ?? '',
      reason: data['reason'] ?? '',
      additionalDetails: data['additionalDetails'] ?? '',
      requestDate: _parse(data['requestDate']) ?? DateTime.now(),
      productTitle: data['productTitle'] ?? '',
      productSize: data['productSize'] ?? '',
      productPrice: (data['productPrice'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 0,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      videoUrl: data['videoUrl'],
      shippingAddress: data['shippingAddress'] != null
          ? AddressModel.fromMap(data['shippingAddress'])
          : null,
      status: ReturnStatus.values.firstWhere(
            (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => ReturnStatus.pending,
      ),
      userId: data['userId'] ?? '',
      adminNotes: data['adminNotes'],
      updatedDate: _parse(data['updatedDate']),

      // refund fields
      refundStatus: data['refundStatus'] ?? "none",
      refundProcessedAt: _parse(data['refundProcessedAt']),
      refundAmount: data['refundAmount']?.toDouble(),
      juspayOrderId: data['juspayOrderId'],
      paymentMethod: data['paymentMethod'],
      refundRequestId: data['refundRequestId'],

      // timeline fields
      approvedAt: _parse(data['approvedAt']),
      pickupScheduledAt: _parse(data['pickupScheduledAt']),
      pickedUpAt: _parse(data['pickedUpAt']),
      receivedAt: _parse(data['receivedAt']),
      refundedAt: _parse(data['refundedAt']),
      completedAt: _parse(data['completedAt']),
    );
  }
}
