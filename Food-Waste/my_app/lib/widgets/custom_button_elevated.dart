import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/login/login.dart';

class custom_button_elevated extends StatelessWidget {
  const custom_button_elevated({
    super.key,
    required this.title,
    this.height,
    this.width,
    required this.onTap,
  });

  final String title;
  final double? height;
  final double? width;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blue)),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
