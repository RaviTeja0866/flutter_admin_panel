import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class RSSpacingStyle{
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: RSSizes.appBarHeight,
    left: RSSizes.defaultSpace,
    bottom: RSSizes.defaultSpace,
    right: RSSizes.defaultSpace,
  );
}