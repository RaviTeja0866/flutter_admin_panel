import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';
import '../../personalization/models/address_model.dart';
import 'order_model.dart';

class UserModel {
  final String? id;

  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  String profilePicture;

  DateTime? createdAt;
  DateTime? updatedAt;

  // 🔹 NOT stored in user document
  List<OrderModel> orders;
  List<AddressModel> addresses;

  UserModel({
    this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.userName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.createdAt,
    this.updatedAt,
    this.orders = const [],
    this.addresses = const [],
  });

  // Helpers
  String get fullName => '$firstName $lastName';
  /// Helper Methods
  String get formattedDate => RSFormatter.formatDate(createdAt);

  String get formattedUpdatedAtDate =>
      RSFormatter.formatDate(updatedAt);

  String get formattedPhoneNo =>
      RSFormatter.formatPhoneNumber(phoneNumber);


  static UserModel empty() => UserModel(email: '');

  // Firestore
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'CreatedAt': createdAt,
      'UpdatedAt': DateTime.now(),
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data();
    if (data == null) return UserModel.empty();

    return UserModel(
      id: document.id,
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      userName: data['UserName'] ?? '',
      email: data['Email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      createdAt: data['CreatedAt']?.toDate(),
      updatedAt: data['UpdatedAt']?.toDate(),
    );
  }
}
