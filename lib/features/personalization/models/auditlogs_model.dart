import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roguestore_admin_panel/utils/formatters/formatter.dart';

/// Model class representing an audit log entry
class AuditLogModel {
  final String? id;

  /// User info
  final String userId;
  final String userName;
  final String userEmail;

  /// Action info
  final String action;        // changing, deleting, updating, uploading, etc.
  final String subject;       // "Changing dates", "Deleting information"
  final String entityType;    // order, product, user, return, etc.
  final String? entityId;     // optional reference ID

  /// Metadata
  final String browser;
  final String? ipAddress;
  final String? userAgent;

  DateTime? createdAt;

  /// Constructor
  AuditLogModel({
    this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.action,
    required this.subject,
    required this.entityType,
    this.entityId,
    required this.browser,
    this.ipAddress,
    this.userAgent,
    this.createdAt,
  });

  /// Helper getters
  String get formattedDate =>
      RSFormatter.formatDate(createdAt);

  String get formattedTime =>
      RSFormatter.formatDate(createdAt);

  /// Empty model
  static AuditLogModel empty() => AuditLogModel(
    userId: '',
    userName: '',
    userEmail: '',
    action: '',
    subject: '',
    entityType: '',
    browser: '',
  );

  /// Convert model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'UserName': userName,
      'UserEmail': userEmail,
      'Action': action,
      'Subject': subject,
      'EntityType': entityType,
      'EntityId': entityId,
      'Browser': browser,
      'IpAddress': ipAddress,
      'UserAgent': userAgent,
      'CreatedAt': createdAt ?? DateTime.now(),
    };
  }

  /// Create model from Firestore snapshot
  factory AuditLogModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return AuditLogModel(
        id: document.id,
        userId: data.containsKey('UserId') ? data['UserId'] ?? '' : '',
        userName: data.containsKey('UserName') ? data['UserName'] ?? '' : '',
        userEmail:
        data.containsKey('UserEmail') ? data['UserEmail'] ?? '' : '',
        action: data.containsKey('Action') ? data['Action'] ?? '' : '',
        subject: data.containsKey('Subject') ? data['Subject'] ?? '' : '',
        entityType:
        data.containsKey('EntityType') ? data['EntityType'] ?? '' : '',
        entityId:
        data.containsKey('EntityId') ? data['EntityId'] : null,
        browser: data.containsKey('Browser') ? data['Browser'] ?? '' : '',
        ipAddress:
        data.containsKey('IpAddress') ? data['IpAddress'] : null,
        userAgent:
        data.containsKey('UserAgent') ? data['UserAgent'] : null,
        createdAt: data.containsKey('CreatedAt')
            ? data['CreatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
      );
    } else {
      return AuditLogModel.empty();
    }
  }
}
