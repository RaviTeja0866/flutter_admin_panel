import 'dart:typed_data';

import 'package:flutter_dropzone_platform_interface/dropzone_file_interface.dart';
import 'package:roguestore_admin_panel/features/media/models/image_model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:roguestore_admin_panel/common/widgets/images/rs_rounded_image.dart';
import 'package:roguestore_admin_panel/features/media/controllers/media_controller.dart';
import 'package:roguestore_admin_panel/features/media/screens/media/widgets/folder_dropdown.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';
import 'package:roguestore_admin_panel/utils/constants/enums.dart';
import 'package:roguestore_admin_panel/utils/constants/image_strings.dart';
import 'package:roguestore_admin_panel/utils/constants/sizes.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

class MediaUploader extends StatelessWidget {
  const MediaUploader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MediaController.instance;
    return Obx(
      () {
        return controller.showImagesUploaderSection.value
            ? Column(
                children: [
                  // Drag and Drop Area
                  RSRoundedContainer(
                    height: 250,
                    showBorder: true,
                    borderColor: RSColors.borderPrimary,
                    backgroundColor: RSColors.primaryBackground,
                    padding: const EdgeInsets.all(RSSizes.defaultSpace),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              DropzoneView(
                                mime: const ['image/jpeg', 'image/png'],
                                cursor: CursorType.Default,
                                operation: DragOperation.copy,
                                onLoaded: () => print('Zone Loaded'),
                                onError: (ev) => print('Zone Error: $ev'),
                                onHover: () => print('Zone Hovered'),
                                onLeave: () => print('Zone Left'),
                                onCreated: (ctrl) =>
                                    controller.dropzoneViewController = ctrl,
                                onDropInvalid: (ev) =>
                                    print('Zone invalid MIME: $ev'),
                                onDropMultiple: (ev) =>
                                    print('Zone drop multiple: $ev'),
                                onDrop: (file) async {
                                  if (file is html.File) {
                                    final bytes = await controller
                                        .dropzoneViewController
                                        .getFileData(
                                            file as DropzoneFileInterface);
                                    final image = ImageModel(
                                      url: '',
                                      file: file,
                                      folder: '',
                                      filename: file.name,
                                      localImageToDisplay:
                                          Uint8List.fromList(bytes),
                                    );
                                    controller.selectedImagesToUpload
                                        .add(image);
                                  } else if (file is String) {
                                    print('zone is drop:$file');
                                  } else {
                                    print(
                                        'Zone unknown Type:${file.runtimeType}');
                                  }
                                },
                              ),

                              // Drop Zone Content
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(RSImages.defaultMultiImageIcon,
                                      width: 50, height: 50),
                                  const SizedBox(height: RSSizes.spaceBtwItems),
                                  const Text('Drag and Drop Images Here'),
                                  const SizedBox(height: RSSizes.spaceBtwItems),
                                  OutlinedButton(
                                    onPressed: () =>
                                        controller.selectLocalImages(),
                                    child: const Text('Select Images'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RSSizes.spaceBtwItems),

                  // Heading & Locally Selected Images
                  if (controller.selectedImagesToUpload.isNotEmpty)
                    RSRoundedContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Folders Dropdown
                              Row(
                                children: [
                                  Text('Select Folder', style: Theme.of(context).textTheme.headlineSmall),
                                  const SizedBox(width: RSSizes.spaceBtwItems),
                                  MediaFolderDropdown(
                                    onChanged: (MediaCategory? newValue) {
                                      if (newValue != null) {
                                        controller.selectedPath.value = newValue;
                                      }
                                    },
                                  ),
                                ],
                              ),

                              // Upload & Remove Button
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () => controller
                                          .selectedImagesToUpload
                                          .clear(),
                                      child: const Text('Remove All')),
                                  const SizedBox(width: RSSizes.spaceBtwItems),
                                  RSDeviceUtils.isMobileScreen(context)
                                      ? const SizedBox.shrink()
                                      : SizedBox(
                                          width: RSSizes.buttonWidth,
                                          child: ElevatedButton(
                                            onPressed: () => controller
                                                .uploadImagesConfirmation(),
                                            child: const Text('Upload'),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: RSSizes.spaceBtwSections),

                          // Locally Selected Images
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: RSSizes.spaceBtwItems / 2,
                            runSpacing: RSSizes.spaceBtwItems / 2,
                            children: controller.selectedImagesToUpload
                                .where((image) =>
                                    image.localImageToDisplay != null)
                                .map((element) => RSRoundedImage(
                                      width: 90,
                                      height: 90,
                                      padding: RSSizes.sm,
                                      imageType: ImageType.memory,
                                      memoryImage: element.localImageToDisplay,
                                      backgroundColor:
                                          RSColors.primaryBackground,
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: RSSizes.spaceBtwSections),

                          // Upload Button For Mobile
                          RSDeviceUtils.isMobileScreen(context)
                              ? SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        controller.uploadImagesConfirmation(),
                                    child: const Text('Upload'),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  const SizedBox(height: RSSizes.spaceBtwSections),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
