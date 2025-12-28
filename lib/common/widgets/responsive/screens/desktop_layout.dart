import 'package:flutter/material.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/headers/header.dart';
import 'package:roguestore_admin_panel/common/widgets/layouts/sidebars/sidebar.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(child: RSSidebar()),
          Expanded(
            flex: 5, // Main content area
            child: Column(
              children: [
                // Header
                const RSHeader(),

                Expanded(
                  child: body ?? const SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
