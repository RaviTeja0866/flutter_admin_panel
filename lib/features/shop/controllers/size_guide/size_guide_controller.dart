import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/abstract/base_data_table_controlller.dart';
import 'package:roguestore_admin_panel/data/repositories/size_guide/size_guide_repository.dart';
import 'package:roguestore_admin_panel/features/shop/models/size_guide_model.dart';

class SizeGuideController extends RSBaseController<SizeGuideModel> {
  static SizeGuideController get instance => Get.find();

  final _sizeGuideRepository = Get.put(SizeGuideRepository());

  @override
  bool containsSearchQuery(SizeGuideModel item, String query) {
    return item.garmentType.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Future<void> deleteItem(SizeGuideModel item)  async{
    await _sizeGuideRepository.deleteSizeGuide(item.id ?? '');
  }

  @override
  Future<List<SizeGuideModel>> fetchItems() async {
    return await _sizeGuideRepository.getAllSizeGuides();
  }
}
