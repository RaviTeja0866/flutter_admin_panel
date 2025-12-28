import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/shop/controllers/size_guide/edit_size_guide_controller.dart';
import 'package:roguestore_admin_panel/features/shop/models/size_guide_model.dart';

import '../../../../../../common/widgets/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/rs_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';

class EditSizeGuideForm extends StatelessWidget {
   EditSizeGuideForm({super.key, required this.sizeGuide});

  final SizeGuideModel sizeGuide;

  final TextEditingController sizeController = TextEditingController();
  final TextEditingController measurementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditSizeGuideController());
    controller.init(sizeGuide);
    return RSRoundedContainer(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Uploader
              Column(
                children: [
                  Obx(
                        () => GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: RSRoundedImage(
                        width: 400,
                        height: 200,
                        backgroundColor: RSColors.primaryBackground,
                        image: controller.imageURL.value.isNotEmpty
                            ? controller.imageURL.value
                            : RSImages.defaultImage,
                        imageType: controller.imageURL.value.isNotEmpty ? ImageType.network : ImageType.asset,
                      ),
                    ),
                  ),
                  SizedBox(height: RSSizes.spaceBtwItems),
                  TextButton(onPressed: () => controller.pickImage(), child: Text('Select Image')),
                ],
              ),
              SizedBox(height: RSSizes.spaceBtwInputFields),

              // Garment Type
              TextFormField(
                controller: controller.garmentTypeController,
                decoration: const InputDecoration(labelText: "Garment Type"),
                validator: (value) => value!.isEmpty ? "Enter garment type" : null,
              ),
              SizedBox(height: RSSizes.md),

              // Measurement Unit
              TextFormField(
                controller: measurementController,
              ),
              const SizedBox(height: RSSizes.md),

              // Input field for adding new size
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: sizeController,
                      decoration: const InputDecoration(labelText: "Enter Size"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (sizeController.text.isNotEmpty) {
                        controller.addSize(sizeController.text);
                        sizeController.clear();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: RSSizes.md),

              // Input field for adding new measurement
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: measurementController,
                      decoration: const InputDecoration(labelText: "Enter Measurement"),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (measurementController.text.isNotEmpty) {
                        controller.addMeasurement(measurementController.text);
                        measurementController.clear();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: RSSizes.md),

              // Display size chart
              SizedBox(
                height: 300,
                child: GetBuilder<EditSizeGuideController>(
                    builder: (controller) =>ListView.builder(
                      itemCount: controller.sizes.length,
                      itemBuilder: (context, index) {
                        String size = controller.sizes[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Size: $size", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => controller.removeSize(size), // Delete size
                                    ),
                                  ],
                                ),
                                SizedBox(height: RSSizes.sm),
                                Column(
                                  children: controller.measurements.map((measurement) {
                                    // Fetch current value for the size and measurement from the sizeChart map
                                    String measurementValue = controller.sizeChart[size]?[measurement] ?? '0';
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: RSSizes.sm), // Adds space between measurements
                                      child: TextFormField(
                                        initialValue: measurementValue.toString(),
                                        decoration: InputDecoration(labelText: measurement),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => controller.updateSizeChart(size, measurement, value),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.updateSizeGuide(sizeGuide),
                  child: const Text("Update Size Guide"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
