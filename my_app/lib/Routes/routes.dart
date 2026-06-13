import 'package:get/get.dart';
import 'package:my_app/pages/login/login.dart';
import 'package:my_app/navigation_menu.dart';
import 'package:my_app/middleware/auth_middleware.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';

  static final pages = [
    GetPage(name: login, page: () => const Login()),
    GetPage(
      name: dashboard,
      page: () => const NavigationMenu(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
