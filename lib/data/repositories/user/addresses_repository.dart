import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/personalization/models/address_model.dart';
import '../authentication/authentication_repository.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<AddressModel>> fetchUserAddresses(String userId) async {
    try{

      final result =await _db.collection('Users').doc(userId).collection('Addresses').get();

      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();

    } catch(e) {
      throw 'Something went wrong while fetching addresses Information. Try again later';
    }
  }

  ///clear the 'Selected' filed for all addresses
  Future<void> updateSelectedField(String addressId, bool selected) async{
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({'SelectedAddress' : selected});
    } catch (e) {
      throw 'Unable to update your address selection. Try again later.';
    }
  }


  ///Store new user order
  Future<String> addAddress(AddressModel address) async{
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentAddress = await _db.collection('Users').doc(userId).collection('Addresses').add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Something went wrong while saving Address information. Try again later.';
    }
  }

}