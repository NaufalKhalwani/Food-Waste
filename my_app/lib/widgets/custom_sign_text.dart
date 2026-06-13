import 'dart:ui';

import 'package:flutter/material.dart';

class custom_sign_text extends StatelessWidget {
  const custom_sign_text({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title,
        style: TextStyle(
          color: Colors.black.withOpacity(0.7),
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: subtitle,
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
