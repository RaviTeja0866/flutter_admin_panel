import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';

import '../../../../../../utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/tag/create_and_update_tag_controller.dart';

class ProductTag extends StatelessWidget {
  final List<String> initialTags; // Accept initial tags from ProductModel

  const ProductTag({super.key, required this.initialTags});

  @override
  Widget build(BuildContext context) {
    final tagController = Get.put(TagController(), permanent: true);

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag Label
          Text('Tags', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: RSSizes.spaceBtwItems),

          // TextFormField for entering tags
          TextFormField(
            controller: tagController.tagTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Tag',
              suffixIcon: Icon(Iconsax.box),
            ),
            onFieldSubmitted: (value) {
              final trimmedValue = value.trim();
              // Add tag if valid and clear text field
              if (trimmedValue.isNotEmpty &&
                  !tagController.selectedTags.contains(trimmedValue)) {
                tagController.addTag(trimmedValue);
                tagController.tagTextController.clear(); // Clear text field
              }
            },
          ),

          SizedBox(height: RSSizes.spaceBtwItems),

          // Display the selected tags as Chips
          Obx(() {
            return Wrap(
              spacing: 8.0, // Horizontal spacing between chips
              runSpacing: 4.0, // Vertical spacing between chips
              children: tagController.selectedTags.map((tag) {
                return FilterChip(
                  label: Text(tag),
                  selected: true,
                  onSelected: (isSelected) {
                    if (!isSelected) {
                      tagController.removeTag(tag); // Remove tag if deselected
                    }
                  },
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
