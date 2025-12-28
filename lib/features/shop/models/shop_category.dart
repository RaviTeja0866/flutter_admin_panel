import 'package:cloud_firestore/cloud_firestore.dart';

// First, create a ShopCategory model
class ShopCategory {
  String id;
  String title;
  String type;  // 'TOP_SELLERS' or 'NEW_ARRIVALS'
  String imageUrl;
  String gender;  // 'men' or 'women'
  bool active;  // Indicates if the category is active

  ShopCategory({
    required this.id,
    required this.title,
    required this.type,
    required this.imageUrl,
    required this.gender,
    required this.active,
  });

  /// Create from Json
  factory ShopCategory.fromJson(Map<String, dynamic> json) {
    return ShopCategory(
      id: json['Id'] ?? '',
      title: json['Title'] ?? '',
      type: json['Type'] ?? '',
      imageUrl: json['ImageUrl'] ?? '',
      gender: json['Gender'] ?? '',
      active: json['Active'] ?? false,
    );
  }

  /// To Json
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Type': type,
      'ImageUrl': imageUrl,
      'Gender': gender,
      'Active': active,
    };
  }

  /// Factory method to create ShopCategoryModel from Firebase snapshot
  factory ShopCategory.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ShopCategory(
      id: document.id,
      title: data['Title'] ?? '',
      type: data['Type'] ?? '',
      imageUrl: data['ImageUrl'] ?? '',
      gender: data['Gender'] ?? '',
      active: data['Active'] ?? false,
    );
  }
}
