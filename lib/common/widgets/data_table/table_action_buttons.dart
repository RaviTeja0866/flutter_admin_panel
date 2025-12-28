import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/utils/constants/colors.dart';

class RSTableActionButtons extends StatelessWidget {
  const RSTableActionButtons(
      {super.key,
       this.view = false,
       this.edit = true,
       this.delete = true,
      this.onViewPressed,
      this.onEditPressed,
      this.onDeletePressed
      });

  // flag to determine whether the view Button is enabled
  final bool view;

  // flag to determine whether the edit Button is enabled
  final bool edit;

  // flag to determine whether the delete Button is enabled
  final bool delete;

  // Callback function for when the view button is pressed
  final VoidCallback? onViewPressed;

  // Callback function for when the edit button is pressed
  final VoidCallback? onEditPressed;

  // Callback function for when the delete button is pressed
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(view)
          IconButton(
            onPressed: onViewPressed,
            icon: Icon(Iconsax.eye, color: RSColors.darkerGrey),
          ),
        if(edit)
          IconButton(
            onPressed: onEditPressed,
            icon: Icon(Iconsax.pen_add, color: RSColors.primary),
          ),

        if(delete)
          IconButton(
            onPressed: onDeletePressed,
            icon: Icon(Iconsax.trash, color: RSColors.error),
          ),
      ],
    );
  }
}
