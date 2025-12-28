//Model class representing Settings data
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  final String? id;
  double shippingCost;
  double? freeShippingThreshold;
  double taxRate;
  String appName;
  String appLogo;

  //constructor for  Settings Model
  SettingsModel({
    this.id,
    this.taxRate = 0.0,
    this.shippingCost = 0.0,
    this.freeShippingThreshold,
    this.appName = '',
    this.appLogo = '',
  });

  //Convert model to json structure for storing data in firebase

  Map<String, dynamic> toJson() {
    return {
      'taxRate': taxRate,
      'shippingCost': shippingCost,
      'freeShippingThreshold': freeShippingThreshold,
      'appName': appName,
      'appLogo': appLogo,
    };
  }

// Factory method to create a UserModel from a firebase document snapshot
  factory SettingsModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    if(document.data() !=null) {
      final data = document.data()!;
       return SettingsModel(
         id: document.id,
         taxRate: (data['taxRate'] as num?)?.toDouble() ?? 0.0,
         shippingCost: (data['shippingCost'] as num?)?.toDouble() ?? 0.0,
         freeShippingThreshold: (data['freeShippingThreshold'] as num?)?.toDouble() ?? 0.0,
         appName: data.containsKey('appName') ? data['appName'] ?? '' : '',
         appLogo: data.containsKey('appLogo') ? data['appLogo'] ?? '' : '',
       );
    }
    return SettingsModel();
  }
}
