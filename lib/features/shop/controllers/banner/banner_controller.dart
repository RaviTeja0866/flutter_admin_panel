import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/banner/banner_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/banner_model.dart';

import '../../../../data/abstract/base_data_table_controlller.dart';

class BannerController extends RSBaseController<BannerModel>{
  static BannerController get instance => Get.find();

  final _bannerRepository = Get.put(BannerRepository());

  @override
  Future<void> deleteItem(BannerModel item) async{
    await _bannerRepository.deleteBanner(item.id ?? '');
  }

  @override
  Future<List<BannerModel>> fetchItems() async{
    return await _bannerRepository.getAllBanners();
  }

  // Method for formatting a route
  String formatRoute(String route) {
    if (route.isEmpty) return ''; // Handle empty route
    if (route.length < 2) return route; // Handle case where there's no second character

    // Remove the leading '/'
    String formatted = route.substring(1);

    // Capitalize the first character
    formatted = formatted[0].toUpperCase() + formatted.substring(1);

    return formatted;
  }

  @override
  bool containsSearchQuery(BannerModel item, String query) {
    return false;
  }

}