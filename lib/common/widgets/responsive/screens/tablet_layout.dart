import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/headers/header.dart';

import '../../layouts/sidebars/sidebar.dart';

class TabletLayout extends StatelessWidget {
  TabletLayout({super.key, this.body});

  final Widget? body;

  /// Global Key to access the scaffold state
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const RSSidebar(),
      appBar: RSHeader(scaffoldKey: scaffoldKey),
      body: body ?? const SizedBox(),
    );
  }
}
