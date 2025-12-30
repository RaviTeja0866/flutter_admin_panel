import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roguestore_admin_panel/utils/formatters/formatter.dart';
import '../../../utils/constants/enums.dart';

class AdminUserModel {
  // ------------------------
  // Identity
  // ------------------------
  final String uid; // Firebase Auth UID
  final String email;

  String firstName;
  String lastName;
  String phoneNumber;

  // ------------------------
  // RBAC
  // ------------------------
  final String roleId; // SUPER_ADMIN, ADMIN, OPERATIONS, VIEWER
  final bool isActive;

  final List<Permission> extraPermissions;
  final List<Permission> revokedPermissions;

  // ------------------------
  // Meta
  // ------------------------
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  // ------------------------
  // Constructor
  // ------------------------
  AdminUserModel({
    required this.uid,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    required this.roleId,
    required this.isActive,
    this.extraPermissions = const [],
    this.revokedPermissions = const [],
    required this.createdAt,
    this.lastLoginAt,
  });

  // ------------------------
  // Helpers
  // ------------------------
  String get fullName => '$firstName $lastName'.trim();

  String get formattedCreatedAt =>
      RSFormatter.formatDate(createdAt);

  String get formattedPhoneNo =>
      RSFormatter.formatPhoneNumber(phoneNumber);

  // ------------------------
  // Firestore
  // ------------------------
  factory AdminUserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return AdminUserModel(
      uid: doc.id,
      email: data['email'],
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      roleId: data['roleId'],
      isActive: data['isActive'] ?? false,
      extraPermissions: _parsePermissions(data['extraPermissions']),
      revokedPermissions: _parsePermissions(data['revokedPermissions']),
      createdAt: data['createdAt'].toDate(),
      lastLoginAt: data['lastLoginAt']?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'roleId': roleId,
      'isActive': isActive,
      'extraPermissions':
      extraPermissions.map((e) => e.name).toList(),
      'revokedPermissions':
      revokedPermissions.map((e) => e.name).toList(),
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }

  static List<Permission> _parsePermissions(List<dynamic>? list) {
    if (list == null) return [];
    return list
        .map((e) => Permission.values.byName(e))
        .toList();
  }
}
