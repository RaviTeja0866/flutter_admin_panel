import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/coupon/coupon_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';

import '../../../../data/services.cloud_storage/RBAC/action_guard.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/loaders.dart';

class EditCouponController extends GetxController {
  static EditCouponController get instance => Get.find();

  final _repo = CouponRepository.instance;

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
  bool _loaded = false;

  final Rxn<CouponModel> coupon = Rxn<CouponModel>();

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
      startDateController.text =
          "${picked.toLocal()}".split(' ')[0]; // Display date in the text field

      // Set expiry date to one day after the selected start date
      expiryDate.value = picked.add(Duration(days: 1));
      endDateController.text = "${expiryDate.value.toLocal()}"
          .split(' ')[0]; // Display updated expiry date
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
      endDateController.text =
          "${picked.toLocal()}".split(' ')[0]; // Display date in the text field
    }
  }

  void addTerm() {
    if (termsController.text.isNotEmpty) {
      offerTerms.add(termsController.text);
      termsController.clear();
    } else {}
  }

  void removeTerm(int index) {
    offerTerms.removeAt(index);
  }

  // ---------------------------------------------------------------------------
  // LOAD COUPON BY ID (REFRESH SAFE)
  // ---------------------------------------------------------------------------
  Future<void> loadCoupon(String couponId) async {
    if (_loaded) return;
    _loaded = true;

    loading(true);

    final data = await _repo.getCouponById(couponId);
    coupon.value = data;

    // Init fields
    code.text = data.title;
    discountType.value = data.discountType;
    isActive.value = data.status;

    discountAmount.text =
        data.discountType == 'flat' ? data.discountValue.toString() : '';
    discountPercentage.text =
        data.discountType == 'percentage' ? data.discountValue.toString() : '';

    minimumPurchase.text = data.minimumPurchase.toString();

    offerTerms
      ..clear()
      ..addAll(data.terms);

    startDate.value = data.startDate;
    expiryDate.value = data.endDate;
    startDateController.text = data.formattedStartDate;
    endDateController.text = data.formattedEndDate;

    loading(false);
  }

  // ---------------------------------------------------------------------------
  // UPDATE COUPON
  // ---------------------------------------------------------------------------
  Future<void> updateCoupon() async {
    await ActionGuard.run(
        permission: Permission.couponUpdate,
        showDeniedScreen: true,
        action: () async {
      try {
        if (!formKey.currentState!.validate()) return;

        final item = coupon.value!;
        item
          ..title = code.text.trim()
          ..discountType = discountType.value
          ..discountValue = double.tryParse(discountAmount.text) ??
              double.tryParse(discountPercentage.text) ??
              0
          ..minimumPurchase = double.tryParse(minimumPurchase.text) ?? 0
          ..status = isActive.value
          ..terms = offerTerms.toList()
          ..startDate = startDate.value
          ..endDate = expiryDate.value
          ..updatedAt = DateTime.now();

        await _repo.updateCoupon(item);

        RSLoaders.success(message: 'Coupon updated successfully');
        Get.offNamed(RSRoutes.coupons);
      } catch (e) {
        RSLoaders.error(message: e.toString());
      }
    });
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
