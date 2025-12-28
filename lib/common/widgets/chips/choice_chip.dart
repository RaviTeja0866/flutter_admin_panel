import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../containers/circular_container.dart';

class RSChoiceChip extends StatelessWidget {
  const RSChoiceChip(
      {super.key, required this.text, required this.selected, this.onSelected});

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = RSHelperFunctions.getColor(text) != null;
    return Theme(
      // use a transparent canvas color to match the existing styling.
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        // use this function to get colors as a chip
        avatar: RSHelperFunctions.getColor(text) != null
            ? RSCircularContainer(width: 50, height: 50, backgroundColor: RSHelperFunctions.getColor(text)!)
            : null,
        selected: selected,
        onSelected: onSelected,
        backgroundColor: isColor ? RSHelperFunctions.getColor(text)! : null,
        labelStyle: TextStyle(color: selected ? RSColors.white : null),
        shape: isColor ? const CircleBorder() : null,
        label: isColor ? const SizedBox() : Text(text),
        padding: isColor ? const EdgeInsets.all(0) : null,
        labelPadding: isColor ? const EdgeInsets.all(0) : null,
      ),
    );
  }
}
