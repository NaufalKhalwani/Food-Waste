import 'package:flutter/material.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/login/login.dart';
import 'package:my_app/Routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.pages,
    );
  }
}
