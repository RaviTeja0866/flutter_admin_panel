import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';

import '../common/widgets/layouts/sidebars/sidebar_controller.dart';

 class RouteObservers extends GetObserver{

  //called when a route name and update the active item in the sidebar accordingly
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sideBarController = Get.put(SidebarController());

    if(previousRoute!= null){
      //check the route name and update the active item in the sidebar accordingly
      for(var routeName in RSRoutes.sideMenuItems){
        if(previousRoute.settings.name == routeName){
          sideBarController.activeItem.value = routeName;
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    final sideBarController = Get.put(SidebarController());

    if(previousRoute!= null){
      //check the route name and update the active item in the sidebar accordingly
      for(var routeName in RSRoutes.sideMenuItems){
        if(previousRoute.settings.name == routeName){
          sideBarController.activeItem.value = routeName;
        }
      }
    }
  }
}