import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagController extends GetxController {
  static TagController get instance => Get.find();

  final RxList<String> selectedTags = <String>[].obs;
  final TextEditingController tagTextController = TextEditingController();

  // Initialize selectedTags with the provided tags
  void setInitialTags(List<String> tags) {
    selectedTags.assignAll(tags); // Directly assign the new list
  }

  // Add a new tag if it doesn't already exist
  void addTag(String tag) {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
    }
  }

  // Remove an existing tag
  void removeTag(String tag) {
    selectedTags.remove(tag);
  }

  // Reset tags to an empty list
  void resetTags() {
    selectedTags.clear();
  }
}
