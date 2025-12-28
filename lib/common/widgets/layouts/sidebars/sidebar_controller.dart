import 'package:get/get.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/utils/device/device_utility.dart';

class SidebarController  extends GetxController{
  final activeItem = RSRoutes.dashboard.obs;
  final hoverItem = ''.obs;

  void changeActiveItem(String route) => activeItem.value =route;

  void changeHoverItem(String route){
    if(!isActive(route)) hoverItem.value = route;
  }
  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route){
    if(!isActive(route)){

      changeActiveItem(route);

      if(RSDeviceUtils.isMobileScreen(Get.context!)) Get.back();

      Get.toNamed(route);
    }
  }
}