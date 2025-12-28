import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'cart_model.dart';

class ExchangeRequestModel {
  final String id;
  final String docId;
  final String orderId;
  final String cartItemId;
  final String userId;
  final String originalSize;
  final String requestedSize;
  final DateTime requestDate;
  ExchangeStatus status;
  final CartItemModel cartItem;
  final String? adminNotes;
  final DateTime? processedDate;
  final DateTime? updatedAt;

  /// New: Timeline steps for UI + Firestore
  final List<ExchangeStep> steps;

  ExchangeRequestModel({
    required this.id,
    this.docId = '',
    required this.orderId,
    required this.cartItemId,
    required this.userId,
    required this.originalSize,
    required this.requestedSize,
    required this.requestDate,
    required this.status,
    required this.cartItem,
    this.adminNotes,
    this.processedDate,
    this.updatedAt,
    required this.steps,
  });

  String get formattedRequestDate =>
      RSHelperFunctions.getFormattedDate(requestDate);

  String get formattedProcessedDate =>
      processedDate != null
          ? RSHelperFunctions.getFormattedDate(processedDate!)
          : 'Not processed';

  bool get canBeCancelled =>
      status == ExchangeStatus.pending || status == ExchangeStatus.accepted;

  bool get isCompleted => status == ExchangeStatus.completed;

  bool get isPending => status == ExchangeStatus.pending;

  /// Empty model with default steps
  static ExchangeRequestModel empty() => ExchangeRequestModel(
    id: '',
    orderId: '',
    cartItemId: '',
    userId: '',
    originalSize: '',
    requestedSize: '',
    requestDate: DateTime.now(),
    status: ExchangeStatus.pending,
    cartItem: CartItemModel.empty(),
    steps: ExchangeRequestModel.defaultSteps(),
  );

  /// Default steps if Firestore has no timeline yet
  static List<ExchangeStep> defaultSteps() {
    return [
      ExchangeStep(
        title: 'Request Submitted',
        description: 'Your exchange request was submitted.',
        timestamp: null,
      ),
      ExchangeStep(
        title: 'Seller Accepted',
        description: 'Your exchange request was accepted.',
        timestamp: null,
      ),
      ExchangeStep(
        title: 'Pickup Scheduled',
        description: 'Courier pickup has been scheduled.',
        timestamp: null,
      ),
      ExchangeStep(
        title: 'Item Picked Up',
        description: 'The item has been picked up by the courier.',
        timestamp: null,
      ),
      ExchangeStep(
        title: 'New Item Shipped',
        description: 'Your replacement item has been shipped.',
        timestamp: null,
      ),
      ExchangeStep(
        title: 'Exchange Completed',
        description: 'Exchange completed successfully.',
        timestamp: null,
      ),
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'cartItemId': cartItemId,
      'userId': userId,
      'originalSize': originalSize,
      'requestedSize': requestedSize,
      'requestDate': Timestamp.fromDate(requestDate),
      'status': status.name,
      'productDetails': cartItem.toJson(),
      'adminNotes': adminNotes,
      'processedDate':
      processedDate != null ? Timestamp.fromDate(processedDate!) : null,
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : Timestamp.fromDate(DateTime.now()),

      /// New: serialize steps
      'steps': steps.map((s) => s.toJson()).toList(),
    };
  }

  factory ExchangeRequestModel.fromMap(Map<String, dynamic> data) {
    DateTime? parse(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    DateTime parseRequired(dynamic value) {
      return parse(value) ?? DateTime.now();
    }

    /// Parse steps if present; otherwise use defaultSteps()
    List<ExchangeStep> parseSteps(dynamic raw) {
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map((m) => ExchangeStep.fromMap(m))
            .toList();
      }
      return ExchangeRequestModel.defaultSteps();
    }

    return ExchangeRequestModel(
      id: data['id'] ?? '',
      docId: data['docId'] ?? '',
      orderId: data['orderId'] ?? '',
      cartItemId: data['cartItemId'] ?? '',
      userId: data['userId'] ?? '',
      originalSize: data['originalSize'] ?? '',
      requestedSize: data['requestedSize'] ?? '',
      requestDate: parseRequired(data['requestDate']),
      status: ExchangeStatus.values.firstWhere(
            (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => ExchangeStatus.pending,
      ),
      cartItem: data['productDetails'] != null
          ? CartItemModel.fromJson(data['productDetails'])
          : CartItemModel.empty(),
      adminNotes: data['adminNotes'],
      processedDate: parse(data['processedDate']),
      updatedAt: parse(data['updatedAt']),
      steps: parseSteps(data['steps']),
    );
  }

  factory ExchangeRequestModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception(
          'Exchange request data is null for document: ${snapshot.id}');
    }

    DateTime? parseTimestampOrString(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    DateTime parseTimestampOrStringDefault(dynamic value) {
      return parseTimestampOrString(value) ?? DateTime.now();
    }

    List<ExchangeStep> parseSteps(dynamic raw) {
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map((m) => ExchangeStep.fromMap(m))
            .toList();
      }
      return ExchangeRequestModel.defaultSteps();
    }

    return ExchangeRequestModel(
      docId: snapshot.id,
      id: data['id'] ?? '',
      orderId: data['orderId'] ?? '',
      cartItemId: data['cartItemId'] ?? '',
      userId: data['userId'] ?? '',
      originalSize: data['originalSize'] ?? '',
      requestedSize: data['requestedSize'] ?? '',
      requestDate: parseTimestampOrStringDefault(data['requestDate']),
      status: ExchangeStatus.values.firstWhere(
            (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => ExchangeStatus.pending,
      ),
      cartItem: data['productDetails'] != null
          ? CartItemModel.fromJson(
        data['productDetails'] as Map<String, dynamic>,
      )
          : CartItemModel.empty(),
      adminNotes: data['adminNotes'],
      processedDate: parseTimestampOrString(data['processedDate']),
      updatedAt: parseTimestampOrString(data['updatedAt']),
      steps: parseSteps(data['steps']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExchangeRequestModel &&
        other.id == id &&
        other.userId == userId;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode;
}

/// Timeline step model used by ExchangeOrderTimeline
class ExchangeStep {
  final String title;
  final String description;
  final DateTime? timestamp;

  ExchangeStep({
    required this.title,
    required this.description,
    required this.timestamp,
  });

  factory ExchangeStep.fromMap(Map<String, dynamic> data) {
    DateTime? parse(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return ExchangeStep(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      timestamp: parse(data['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'timestamp':
      timestamp != null ? Timestamp.fromDate(timestamp!) : null,
    };
  }
}
