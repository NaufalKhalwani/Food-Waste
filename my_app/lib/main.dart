import 'package:flutter/material.dart';
import 'package:my_app/navigation_menu.dart';
import 'package:my_app/pages/beranda/beranda.dart';
import 'package:my_app/pages/donasi/donasi.dart';
import 'package:my_app/pages/register/register.dart';
import 'package:get/get.dart';

void main() {
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
