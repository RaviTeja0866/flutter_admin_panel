import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';

class AddressModel {
  String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final DateTime? dateTime;
  bool selectedAddress;
  final String addressType;

  AddressModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    this.dateTime,
    this.selectedAddress = true,
    required this.addressType,
  });

  // Combine firstName and lastName
  String get fullName => '$firstName $lastName';

  String get formattedPhoneNo => RSFormatter.formatPhoneNumber(phoneNumber);

  static AddressModel empty() => AddressModel(
    id: '',
    firstName: '',
    lastName: '',
    phoneNumber: '',
    street: '',
    city: '',
    state: '',
    postalCode: '',
    addressType: 'Home',
  );

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'State': state,
      'PostalCode': postalCode,
      'DateTime': DateTime.now(),
      'SelectedAddress': selectedAddress,
      'AddressType': addressType,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['Id']?.toString() ?? '',
      firstName: data['FirstName']?.toString() ?? '',
      lastName: data['LastName']?.toString() ?? '',
      phoneNumber: data['PhoneNumber']?.toString() ?? '',
      street: data['Street']?.toString() ?? '',
      city: data['City']?.toString() ?? '',
      state: data['State']?.toString() ?? '',
      postalCode: data['PostalCode']?.toString() ?? '',
      selectedAddress: data['SelectedAddress'] == true,
      dateTime: _safeDate(data['DateTime']),
      addressType: data['AddressType']?.toString() ?? 'Home',
    );
  }

  factory AddressModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return AddressModel(
      id: snapshot.id,
      firstName: data['FirstName'] ?? '',
      lastName: data['LastName'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      street: data['Street'] ?? '',
      city: data['City'] ?? '',
      state: data['State'] ?? '',
      postalCode: data['PostalCode'] ?? '',
      dateTime: (data['DateTime'] as Timestamp).toDate(),
      selectedAddress: data['SelectedAddress'] as bool,
      addressType: data['AddressType'] as String? ?? 'Home',
    );
  }

  @override
  String toString() {
    return '$street, $city, $state, $postalCode';
  }

  static DateTime? _safeDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
