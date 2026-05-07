import 'dart:ui';

import 'package:flutter/material.dart';

class SignUpWith extends StatelessWidget {
  const SignUpWith({super.key, required this.icon, this.ontap});

  final String icon;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey),
        ),
        child: Image.network(icon, height: 24),
      ),
    );
  }
}
