import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/coupon/coupon_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';

import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';

class EditCouponController extends GetxController {
  static EditCouponController get instance => Get.find();

  final loading = false.obs;
  final isActive = false.obs;
  RxString discountType = 'flat'.obs; // Default value is 'flat'

  // Controllers for text fields
  final code = TextEditingController();
  final discountAmount = TextEditingController();
  final discountPercentage = TextEditingController();
  final minimumPurchase = TextEditingController();
  final termsController = TextEditingController();

  // Date Controllers
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startDate = DateTime.now().obs;
  final expiryDate = DateTime.now().obs;
  var offerTerms = <String>[].obs;
  final formKey = GlobalKey<FormState>();

  // Initialize Coupon
  void initCoupon(CouponModel coupon) {
     code.text = coupon.title;

      if (coupon.discountType == 'percentage') {
        discountAmount.clear();
        discountPercentage.text = coupon.discountValue.toString();
      } else {
        discountAmount.text = coupon.discountValue.toString();
      }

      minimumPurchase.text = coupon.minimumPurchase.toString();
      discountAmount.text = coupon.discountValue.toString();
      isActive.value = coupon.status;

      offerTerms.clear(); // Clear existing terms first
      offerTerms.addAll(coupon.terms);

      startDate.value = coupon.startDate;
      expiryDate.value = coupon.endDate;
      startDateController.text = coupon.formattedStartDate;
      endDateController.text = coupon.formattedEndDate;
  }

  // Format DateTime to String
  String formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  // Method to select start date
  Future<void> selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      startDate.value = picked; // Use `.value` to update the Rx variable
      startDateController.text = "${picked.toLocal()}".split(' ')[0]; // Display date in the text field

      // Set expiry date to one day after the selected start date
      expiryDate.value = picked.add(Duration(days: 1));
      endDateController.text = "${expiryDate.value.toLocal()}".split(' ')[0]; // Display updated expiry date
    }
  }

  // Method to select Expiry date manually (optional)
  Future<void> selectExpiryDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      expiryDate.value = picked; // Use `.value` to update the Rx variable
      endDateController.text = "${picked.toLocal()}".split(' ')[0]; // Display date in the text field
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
      offerTerms.removeAt(index);
  }
  // Update Coupon

  Future<void> updateCoupon(CouponModel coupon) async {
    try {
      loading(true);

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        loading(false);
        RSLoaders.errorSnackBar(
          title: 'No Internet',
          message: 'Please check your internet connection.',
        );
        return;
      }

      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        loading(false);
        RSLoaders.errorSnackBar(
          title: 'Validation Failed',
          message: 'Please fill in all required fields correctly.',
        );
        return;
      }


      // Map Data
      coupon.title = code.text.trim();
      coupon.discountType = discountType.value;
      coupon.discountValue = double.tryParse(discountAmount.text) ??
          double.tryParse(discountPercentage.text) ?? 0.0;
      coupon.minimumPurchase = double.tryParse(minimumPurchase.text) ?? 0.0;
      coupon.status = isActive.value;
      coupon.terms = offerTerms.toList(); // Use offerTerms directly instead of splitting termsController
      coupon.startDate = startDate.value;
      coupon.endDate = expiryDate.value;
      coupon.updatedAt = DateTime.now();


      await CouponRepository.instance.updateCoupon(coupon);

      RSLoaders.successSnackBar(
        title: 'Success',
        message: 'Coupon updated successfully.',
      );

      resetFields();

    } catch (e) {
      loading(false);
      RSLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    } finally {
      loading(false);
    }
  }

  // Reset Fields
  void resetFields() {
    isActive(false);
    discountAmount.clear();
    discountPercentage.clear();
    minimumPurchase.clear();
    code.clear();
    startDate.value = DateTime.now();
    expiryDate.value = DateTime.now();
  }
}
