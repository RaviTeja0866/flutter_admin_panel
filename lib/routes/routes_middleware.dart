import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roguestore_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';

class RSRouteMiddleware extends GetMiddleware{


  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated ? null : RouteSettings(name: RSRoutes.login);
  }
}