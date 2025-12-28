import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../data/repositories/coupon/coupon_repository.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../models/coupon_model.dart';

class CreateCouponController extends GetxController {
  static CreateCouponController get instance => Get.find();


  // Controllers for text fields
  final code = TextEditingController();
  final discountAmount = TextEditingController();
  final discountPercentage = TextEditingController();
  final minimumPurchase = TextEditingController();
  final termsController = TextEditingController();

  // Date Controllers
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final couponRepository = Get.put(CouponRepository());

  // Reactive variables
  var isActive = false.obs;
  var offerTerms = <String>[].obs;
  RxString discountType = 'flat'.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  final formKey = GlobalKey<FormState>();

  Future<void> selectStartDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        startDate.value = picked;
        startDateController.text = "${picked.toLocal()}".split(' ')[0];
      } else {
      }
  }

  Future<void> selectExpiryDate(BuildContext context) async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        endDate.value = picked;
        endDateController.text = "${picked.toLocal()}".split(' ')[0];
      } else {
      }
  }

  void addTerm() {
      if (termsController.text.isNotEmpty) {
        offerTerms.add(termsController.text);
        termsController.clear();
      } else {
      }
  }

  void removeTerm(int index) {
      final removedTerm = offerTerms[index];
      offerTerms.removeAt(index);
  }

  void editTerm(int index, String newTerm) {
      final oldTerm = offerTerms[index];
      offerTerms[index] = newTerm;
  }

  Future<void> createCoupon() async {
    try {
      RSFullScreenLoader.popUpCircular();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        RSFullScreenLoader.stopLoading();
        return;
      }


      if (code.text.trim().isEmpty || discountAmount.text.trim().isEmpty || startDate.value == null || endDate.value == null) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Validation Error', message: 'Please fill all required fields.');
        return;
      }

      if (startDate.value!.isAfter(endDate.value!)) {
        RSFullScreenLoader.stopLoading();
        RSLoaders.errorSnackBar(title: 'Date Error', message: 'Start date cannot be after expiry date.');
        return;
      }

      final newCoupon = CouponModel(
        id: '',
        title: code.text,
        discountType: discountType.value,
        discountValue: discountType.value == 'percentage'
            ? double.tryParse(discountPercentage.text) ?? 0.0
            : double.tryParse(discountAmount.text) ?? 0.0,
        minimumPurchase: double.tryParse(minimumPurchase.text) ?? 0.0,
        startDate: DateTime.parse(startDateController.text),
        endDate: DateTime.parse(endDateController.text),
        terms: offerTerms.toList(), // Changed from termsController.text.split(',') to offerTerms.toList()
        status: isActive.value,
      );


      final couponId = await couponRepository.createCoupon(newCoupon);
      newCoupon.id = couponId;

      resetFields();
      RSFullScreenLoader.stopLoading();
      RSLoaders.successSnackBar(title: 'Success', message: 'Coupon created successfully.');

    } catch (e) {
      RSFullScreenLoader.stopLoading();
      RSLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void resetFields() {
      code.clear();
      discountAmount.clear();
      minimumPurchase.clear();
      startDateController.clear();
      endDateController.clear();
      termsController.clear();
      offerTerms.clear(); // Added clearing of offerTerms
      isActive.value = false;
      startDate.value = null;
      endDate.value = null;
  }
}