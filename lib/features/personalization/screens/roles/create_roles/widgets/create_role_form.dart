import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/common/widgets/containers/rounded_container.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controllers/roles/create_role_controller.dart';

class CreateRoleFormScreen extends StatelessWidget {
  CreateRoleFormScreen({super.key});

  final CreateRoleController controller = Get.put(CreateRoleController());

  @override
  Widget build(BuildContext context) {
    return RSRoundedContainer(
      width: 620,
      child: Padding(
        padding: const EdgeInsets.all(RSSizes.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // ROLE NAME
              // ------------------------------------------------
              TextFormField(
                controller: controller.roleNameController,
                decoration: const InputDecoration(labelText: 'Role Name'),
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Enter role name'
                    : null,
              ),

              const SizedBox(height: RSSizes.spaceBtwInputFields),

              // ------------------------------------------------
              // DESCRIPTION
              // ------------------------------------------------
              TextFormField(
                controller: controller.descriptionController,
                decoration:
                const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),

              const SizedBox(height: RSSizes.spaceBtwInputFields),

              // ------------------------------------------------
              // PERMISSIONS DROPDOWN (WITH SCROLL)
              // ------------------------------------------------
              Obx(() {
                return InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Permissions',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------------------------
                      // DROPDOWN HEADER
                      // -------------------------------
                      InkWell(
                        onTap: controller.togglePermissionDropdown,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.selectedGroupLabels.isEmpty
                                    ? 'Select Permissions'
                                    : controller.selectedGroupLabels
                                    .join(', '),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: controller
                                      .selectedGroupLabels.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.black,
                                ),
                              ),
                            ),
                            Icon(
                              controller.isPermissionDropdownOpen.value
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),

                      // -------------------------------
                      // GROUPS + ACTIONS (SCROLLABLE)
                      // -------------------------------
                      if (controller.isPermissionDropdownOpen.value)
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 12),
                          child: SizedBox(
                            height: 260, // 👈 SCROLL LIMIT
                            child: SingleChildScrollView(
                              child: Column(
                                children: controller.permissionGroups
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final group = entry.value;
                                  final isLastGroup = index ==
                                      controller.permissionGroups.length -
                                          1;

                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // GROUP HEADER
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 40,
                                            child: CustomPaint(
                                              painter:
                                              TreeLinePainter(
                                                lineType: isLastGroup
                                                    ? TreeLineType
                                                    .corner
                                                    : TreeLineType
                                                    .branch,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              group.label,
                                              style: const TextStyle(
                                                  fontWeight:
                                                  FontWeight.w500),
                                            ),
                                          ),
                                          Checkbox(
                                            value: controller
                                                .isGroupChecked(
                                              group.key,
                                              group.actions,
                                            ),
                                            tristate: true,
                                            onChanged: (v) {
                                              controller.toggleGroup(
                                                group.key,
                                                group.actions,
                                                v ?? false,
                                              );
                                            },
                                          ),
                                        ],
                                      ),

                                      // ACTIONS
                                      ...group.actions
                                          .asMap()
                                          .entries
                                          .map((actionEntry) {
                                        final actionIndex =
                                            actionEntry.key;
                                        final action =
                                            actionEntry.value;
                                        final isLastAction =
                                            actionIndex ==
                                                group.actions.length -
                                                    1;
                                        final key =
                                            '${group.key}.$action';

                                        return Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 40,
                                              child: CustomPaint(
                                                painter:
                                                TreeLinePainter(
                                                  lineType:
                                                  isLastGroup
                                                      ? TreeLineType
                                                      .empty
                                                      : TreeLineType
                                                      .vertical,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 24,
                                              height: 40,
                                              child: CustomPaint(
                                                painter:
                                                TreeLinePainter(
                                                  lineType:
                                                  isLastAction
                                                      ? TreeLineType
                                                      .corner
                                                      : TreeLineType
                                                      .branch,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child:
                                              CheckboxListTile(
                                                dense: true,
                                                contentPadding:
                                                EdgeInsets.zero,
                                                title: Text(
                                                    action.capitalizeFirst!),
                                                value: controller
                                                    .selectedPermissions[
                                                key] ??
                                                    false,
                                                onChanged: (v) {
                                                  controller
                                                      .togglePermission(
                                                    key,
                                                    v ?? false,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: RSSizes.spaceBtwInputFields),

              // ------------------------------------------------
              // OTHER PERMISSIONS
              // ------------------------------------------------
              TextFormField(
                controller: controller.otherPermissionController,
                decoration: const InputDecoration(
                  labelText: 'Other (custom permissions)',
                  hintText:
                  'Comma separated (example: reports.export)',
                ),
              ),

              const SizedBox(height: RSSizes.spaceBtwInputFields),

              // ------------------------------------------------
              // SAVE
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveRole,
                  child: const Text('Save Role'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------
// TREE LINE PAINTER (UNCHANGED)
// ------------------------------------------------
enum TreeLineType { vertical, branch, corner, empty }

class TreeLinePainter extends CustomPainter {
  final TreeLineType lineType;

  TreeLinePainter({required this.lineType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    switch (lineType) {
      case TreeLineType.vertical:
        canvas.drawLine(
          Offset(centerX, 0),
          Offset(centerX, size.height),
          paint,
        );
        break;
      case TreeLineType.branch:
        canvas.drawLine(
          Offset(centerX, 0),
          Offset(centerX, size.height),
          paint,
        );
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(size.width, centerY),
          paint,
        );
        break;
      case TreeLineType.corner:
        canvas.drawLine(
          Offset(centerX, 0),
          Offset(centerX, centerY),
          paint,
        );
        canvas.drawLine(
          Offset(centerX, centerY),
          Offset(size.width, centerY),
          paint,
        );
        break;
      case TreeLineType.empty:
        break;
    }
  }

  @override
  bool shouldRepaint(TreeLinePainter oldDelegate) => false;
}
