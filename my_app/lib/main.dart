import 'package:flutter/material.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/navigation_menu.dart';
import 'package:my_app/pages/beranda/beranda.dart';
import 'package:my_app/pages/donasi/donasi.dart';
import 'package:my_app/pages/register/register.dart';
import 'package:get/get.dart';

import 'package:my_app/controllers/food_controller.dart';

void main() {
  Get.put(AuthController());
  Get.put(FoodController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Register(),
    );
  }
}
