import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/abstract/base_data_table_controlller.dart';
import 'package:roguestore_admin_panel/data/repositories/coupon/coupon_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/coupon_model.dart';

class CouponController extends RSBaseController<CouponModel> {
  static CouponController get instance => Get.find();

  final _couponRepository = Get.put(CouponRepository());

  @override
  Future<List<CouponModel>> fetchItems() async {
    final coupons = await _couponRepository.getAllCoupons();
    filteredItems.assignAll(coupons); // Update filteredItems from base controller
    return coupons;
  }

  @override
  bool containsSearchQuery(CouponModel item, String query) {
    return item.title.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(CouponModel item) async {
    await _couponRepository.deleteCoupon(item.id);
  }

  void sortByCode(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) => coupon.title.toLowerCase());
  }

  void sortByDiscount(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) => coupon.discountValue);
  }

  void sortByStartDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) => coupon.startDate?.toString() ?? '');
  }

  void sortByEndDate(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (CouponModel coupon) => coupon.endDate?.toString() ?? '');
  }
}
