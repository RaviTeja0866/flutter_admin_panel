  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:roguestore_admin_panel/utils/formatters/formatter.dart';

  class CouponModel {
    String id;
    String title;
    String discountType; // "flat" or "percentage"
    double discountValue;
    double minimumPurchase;
    List<String>? applicableProducts; // List of product IDs
    DateTime startDate;
    DateTime endDate;
    List<String> terms; // List of terms and conditions
    bool status; // "active", "expired", "upcoming"
    DateTime? createdAt;
    DateTime? updatedAt;

    CouponModel({
      required this.id,
      required this.title,
      required this.discountType,
      required this.discountValue,
      required this.minimumPurchase,
      this.applicableProducts,
      required this.startDate,
      required this.endDate,
      required this.terms,
      this.status = false,
      this.createdAt,
      this.updatedAt,
    });

    /// Formatted Dates for UI
    String get formattedStartDate => RSFormatter.formatDate(startDate);
    String get formattedEndDate => RSFormatter.formatDate(endDate);
    String get formattedCreatedDate => createdAt != null ? RSFormatter.formatDate(createdAt!) : 'N/A';
    String get formattedUpdatedDate => updatedAt != null ? RSFormatter.formatDate(updatedAt!) : 'N/A';

    /// Empty Coupon Helper
    static CouponModel empty() => CouponModel(
      id: '',
      title: '',
      discountType: '',
      discountValue: 0.0,
      minimumPurchase: 0.0,
      applicableProducts: [],
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      terms: [],
      status:  false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    /// Convert Model to JSON for Firebase
    Map<String, dynamic> toJson() {

      final json = {
        'Id': id,
        'Title': title,
        'DiscountType': discountType,
        'DiscountValue': discountValue,
        'MinimumPurchase': minimumPurchase,
        'ApplicableProducts': applicableProducts,
        'StartDate': Timestamp.fromDate(startDate),
        'EndDate': Timestamp.fromDate(endDate),
        'Terms': terms,
        'Status': status,
        'CreatedAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
        'UpdatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
      };

      return json;
    }

    /// Convert Firebase Snapshot to CouponModel
    factory CouponModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
      final data = document.data();

      if (data == null) {
        return CouponModel.empty();
      }

      final terms = List<String>.from(data['Terms'] ?? []);

      final coupon = CouponModel(
        id: document.id,
        title: data['Title'] ?? '',
        discountType: data['DiscountType'] ?? '',
        discountValue: (data['DiscountValue'] ?? 0.0).toDouble(),
        minimumPurchase: (data['MinimumPurchase'] ?? 0.0).toDouble(),
        applicableProducts: List<String>.from(data['ApplicableProducts'] ?? []),
        startDate: (data.containsKey('StartDate') && data['StartDate'] != null)
            ? (data['StartDate'] as Timestamp).toDate()
            : DateTime.now(),
        endDate: (data.containsKey('EndDate') && data['EndDate'] != null)
            ? (data['EndDate'] as Timestamp).toDate()
            : DateTime.now(),
        terms: terms,
        status: data['Status'] ?? false,
        createdAt: data.containsKey('CreatedAt') && data['CreatedAt'] != null
            ? (data['CreatedAt'] as Timestamp).toDate()
            : null,
        updatedAt: data.containsKey('UpdatedAt') && data['UpdatedAt'] != null
            ? (data['UpdatedAt'] as Timestamp).toDate()
            : null,
      );

      return coupon;
    }

  }
