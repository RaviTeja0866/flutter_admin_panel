import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';

import '../../../../../../utils/constants/sizes.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/tag/create_and_update_tag_controller.dart';

class ProductTag extends StatelessWidget {
  const ProductTag({super.key});

  @override
  Widget build(BuildContext context) {
    final tagController = Get.put(TagController());

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
              print('TextFormField onFieldSubmitted triggered with value: "$value"');

              // Add tag on pressing Enter if it's valid
              if (value.trim().isNotEmpty && !tagController.selectedTags.contains(value.trim())) {
                print('Adding tag: "$value"');
                tagController.addTag(value.trim());
              } else {
                print('Tag is either empty or already exists in the list: "$value"');
              }
            },
          ),

          SizedBox(height: RSSizes.spaceBtwItems),

          // Display the selected tags as Chips
          Obx(() {
            print('Selected tags list updated: ${tagController.selectedTags}');
            return Wrap(
              spacing: 8.0, // Horizontal spacing between chips
              runSpacing: 4.0, // Vertical spacing between chips
              children: tagController.selectedTags.map((tag) {
                return FilterChip(
                  label: Text(tag),
                  selected: true,
                  onSelected: (isSelected) {
                    print('FilterChip onSelected triggered for tag: "$tag", isSelected: $isSelected');
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
