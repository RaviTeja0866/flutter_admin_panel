import 'package:cloud_firestore/cloud_firestore.dart';

class RoleModel {
  final String id;

  /// Core
  final String name;
  final String description;

  /// RBAC
  final List<String> permissions;

  /// Audit
  final String? createdBy;     // adminId
  final String? updatedBy;     // adminId
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Status
  final bool isActive;
  final bool isSystemRole;     // SuperAdmin, Owner, etc.

  RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isActive = true,
    this.isSystemRole = false,
  });

  /// ------------------------------------------------------------
  /// FIRESTORE
  /// ------------------------------------------------------------
  factory RoleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

    final Timestamp? createdTs = data['createdAt'];
    final Timestamp? updatedTs = data['updatedAt'];

    return RoleModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      createdAt: createdTs?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: updatedTs?.toDate(),
      isActive: data['isActive'] ?? true,
      isSystemRole: data['isSystemRole'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'permissions': permissions,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : null,
      'isActive': isActive,
      'isSystemRole': isSystemRole,
    };
  }

  RoleModel copyWith({
    String? name,
    String? description,
    List<String>? permissions,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return RoleModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      createdBy: createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isActive: isActive ?? this.isActive,
      isSystemRole: isSystemRole,
    );
  }
}
