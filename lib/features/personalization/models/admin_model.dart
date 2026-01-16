import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roguestore_admin_panel/utils/formatters/formatter.dart';
import '../../../utils/constants/enums.dart';

class AdminUserModel {
  // ------------------------
  // Identity
  // ------------------------
  final String id; // Firebase Auth UID
  final String email;

  String fullName;
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
    required this.id,
    required this.email,
    this.fullName = '',
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
      id: doc.id,
      email: data['email'],
      fullName: data['fullName'] ?? '',
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
      'fullName': fullName,
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

  static List<Permission> _parsePermissions(dynamic raw) {
    if (raw == null) return [];

    if (raw is List) {
      return raw
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .where((e) =>
          Permission.values.any((p) => p.name == e))
          .map((e) => Permission.values.byName(e))
          .toList();
    }

    if (raw is Map) {
      return raw.entries
          .where((e) =>
      e.key.isNotEmpty &&
          e.value == true &&
          Permission.values.any((p) => p.name == e.key))
          .map((e) => Permission.values.byName(e.key))
          .toList();
    }

    return [];
  }
}
