import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import '../../../../controllers/tag/create_and_update_tag_controller.dart';

class ProductTags extends StatelessWidget {
  const ProductTags({super.key});

  @override  Widget build(BuildContext context) {
    final createTagController = Get.put(CreateTagController());
    final formKey = GlobalKey<FormState>();  // Create a global key for the form

    return RSRoundedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags label
          Text(
            'Tags',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: RSSizes.spaceBtwItems),

          // Form for adding tags
          Form(
            key: formKey,  // Assign the form key to Form widget
            child: Column(
              children: [
                TextFormField(
                  controller: createTagController.tags,
                  decoration: const InputDecoration(
                    labelText: 'Add Tag',
                    hintText: 'Type and press enter to add',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value) {
                    if (formKey.currentState?.validate() ?? false) {
                      // Only add the tag if the form is valid
                      if (value.isNotEmpty &&
                          !createTagController.selectedTag.value.tags.contains(value)) {
                        createTagController.selectedTag.update((tag) {
                          tag?.tags.add(value);
                        });
                        createTagController.tags.clear();
                      }
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tag cannot be empty';
                    }
                    return null;  // Return null if valid
                  },
                ),
                const SizedBox(height: RSSizes.spaceBtwItems),
              ],
            ),
          ),

          // Display selected tags as chips
          Obx(
                () => Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: createTagController.selectedTag.value.tags
                  .map(
                    (tag) => Chip(
                  backgroundColor: Colors.blue[100],
                  label: Text(
                    tag,
                    style: const TextStyle(color: Colors.black),
                  ),
                  avatar: const Icon(
                    Icons.check,
                    color: Colors.blue,
                  ),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => createTagController.selectedTag
                      .update((selected) {
                    selected?.tags.remove(tag);
                  }),
                ),
              )
                  .toList(),
            ),
          ),

          // Save button for tags
          const SizedBox(height: RSSizes.spaceBtwItems),
          ElevatedButton(
            onPressed: () {
              // Validate the form before saving
              if (formKey.currentState?.validate() ?? false) {
                String tagName = createTagController.tags.text.trim();
                if (tagName.isNotEmpty) {
                  // Only save the tag if the name is not empty
                  createTagController.saveTag().then((_) {
                    // Reset input fields after saving
                    createTagController.resetFields();
                  }).catchError((error) {
                    print("Error adding tag: $error");
                  });
                } else {
                  print("Tag name cannot be empty.");
                }
              }
            },
            child: const Text('Save Tags'),
          ),
        ],
      ),
    );
  }
}
