import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? id;
  String imageUrl;
  String targetScreen;
  bool active;
  bool isNavigable; // New property
  String type; // "category" or "offer"
  String value; // e.g., "office wear" or "buy2get1"
  DateTime? startDate;
  DateTime? endDate;

  BannerModel({
    this.id,
    required this.targetScreen,
    required this.active,
    required this.imageUrl,
    this.isNavigable = true, // Default value is true
    required this.type,
    required this.value,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'ImageUrl': imageUrl,
      'TargetScreen': targetScreen,
      'Active': active,
      'IsNavigable': isNavigable,
      'type': type,
      'value': value,
      'startDate': startDate!.toIso8601String(),
      'endDate': endDate!.toIso8601String(),
    };
  }

  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return BannerModel(
      id:snapshot.id,
      imageUrl: data['ImageUrl'] ?? '',
      targetScreen: data['TargetScreen'] ?? '',
      active: data['Active'] ?? false,
      isNavigable: data['IsNavigable'] ?? true,
      type: data['type'] ?? '',
      value: data['value'] ?? '',
      startDate:
          DateTime.parse(data['startDate'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(data['endDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}
