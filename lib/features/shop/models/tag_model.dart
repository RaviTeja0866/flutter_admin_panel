import 'package:cloud_firestore/cloud_firestore.dart';

class TagModel {
  String id;
  final String name;
  final DateTime createdAt;
  final List<String> tags;

  // Constructor
  TagModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.tags,
  });

  // Named constructor to create an empty tag (useful for resetting fields)
  factory TagModel.empty() {
    return TagModel(
      id: '',
      name: '',
      createdAt: DateTime.now(),
      tags: [],
    );
  }

  // Convert Firestore snapshot to TagModel
  factory TagModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print("Tag data from Firestore: $data");

    return TagModel(
      id: doc.id, // Firestore document ID
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }


  // Convert TagModel to JSON format (for Firestore)
  Map<String, dynamic> toJson() {
    if (name.isEmpty || tags.isEmpty) {
      print("Warning: Some fields are missing or empty.");
    }
    return {
      'name': name,
      'createdAt': createdAt,
      'tags': tags,
    };
  }

}
