import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = AuthController.instance;
    if (!auth.isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
