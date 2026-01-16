import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/banner/banner_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/coupon/coupon_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/order/order_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/product/product_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/roles/role_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/shop_category/shop_category_repository.dart';
import 'package:roguestore_admin_panel/data/repositories/size_guide/size_guide_repository.dart';
import 'package:roguestore_admin_panel/features/authentication/controllers/admin_auth_controller.dart';
import 'package:roguestore_admin_panel/features/personalization/controllers/settings_controller.dart';
import 'package:roguestore_admin_panel/utils/helpers/network_manager.dart';

import '../data/repositories/admin/admin_repository.dart';
import '../data/repositories/brand/brand_repository.dart';
import '../data/repositories/category/category_repository.dart';
import '../data/repositories/user/user_repository.dart';
import '../features/personalization/controllers/user_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    // -- Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => UserProfileController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);

    Get.lazyPut(() => ShopCategoryRepository(), fenix: true);
    Get.lazyPut(() => CategoryRepository(), fenix: true);
    Get.lazyPut(() => BrandRepository(), fenix: true);
    Get.lazyPut(() => UserRepository(), fenix: true);
    Get.lazyPut(() => BannerRepository(), fenix: true);

    Get.lazyPut(() => ProductRepository(), fenix: true);
    Get.lazyPut(() => OrderRepository(), fenix: true);
    Get.lazyPut(() => CouponRepository(), fenix: true);
    Get.lazyPut(() => SizeGuideRepository(), fenix: true);

    Get.lazyPut(() => AdminRepository(), fenix: true);
    Get.lazyPut(() => RoleRepository(), fenix: true);

  }
}
