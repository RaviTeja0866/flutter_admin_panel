import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

class RSTableHeader extends StatelessWidget {
  const RSTableHeader({
    super.key,
    this.onPressed,
    this.secondButtonOnPressed,
    this.buttonText = 'Add',
    this.secondButtonText = 'Button 2',
    this.searchController,
    this.searchOnChanged,
    this.showLeftWidget = true,
    this.showSecondButton = false,
  });

  final Function()? onPressed;
  final Function()? secondButtonOnPressed;   // new
  final String buttonText;
  final String secondButtonText;             // new
  final bool showLeftWidget;
  final bool showSecondButton;               // new
  final TextEditingController? searchController;
  final Function(String)? searchOnChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: RSDeviceUtils.isDesktopScreen(context) ? 3 : 1,
          child: showLeftWidget
              ? Row(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ),

              if (showSecondButton) const SizedBox(width: 8),

              if (showSecondButton)
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: secondButtonOnPressed,
                    child: Text(secondButtonText),
                  ),
                ),
            ],
          )
              : const SizedBox.shrink(),
        ),

        Expanded(
          flex: RSDeviceUtils.isDesktopScreen(context) ? 4 : 1,
          child: TextFormField(
            controller: searchController,
            onChanged: searchOnChanged,
            decoration: const InputDecoration(
              hintText: 'Search here',
              prefixIcon: Icon(Iconsax.search_normal),
            ),
          ),
        ),
      ],
    );
  }
}
