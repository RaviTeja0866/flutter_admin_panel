import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roguestore_admin_panel/utils/formatters/formatter.dart';

class CategoryModel {
  String id;
  String? slug;
  String name;
  String image;
  String parentId;
  bool isFeatured;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    this.isFeatured = false,
    this.parentId = '',
    this.createdAt,
    this.updatedAt,
  });

  String get formattedDate => RSFormatter.formatDate(createdAt);
  String get formattedUpdatedDate => RSFormatter.formatDate(updatedAt);

  //Empty Helper Function
  static CategoryModel empty() => CategoryModel(id: '', name: '', slug: '', image: '', isFeatured: false);

  ///Convert model to Json structure so that you can store data in firebase
  toJson() {
    return {
      'Id': id,
      'Name': name,
      'Slug':slug,
      'Image': image,
      'ParentId': parentId,
      'IsFeatured': isFeatured,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt = DateTime.now(),
    };
  }

  /// Map Json oriented document snapshot form firebase to UserModel
  factory CategoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      /// Handle null and empty values properly
      return CategoryModel(
        id: document.id,
        name: data['Name'] ?? '',
        slug: data['Slug'] ?? '',
        image: data['Image'] ?? '',
        parentId: data['ParentId'] ?? '',
        isFeatured:data['IsFeatured'] ?? false,
        createdAt: data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() : null,
        updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() : null,
      );
    } else {
      return CategoryModel.empty();
    }
  }
}
