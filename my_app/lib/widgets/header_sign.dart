import 'dart:ui';

import 'package:flutter/material.dart';

class header_sign extends StatelessWidget {
  const header_sign({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.withIcon = true,
    this.urlLogo,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  final String? urlLogo;

  final bool withIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          withIcon
              ? Icon(icon, size: 100, color: Colors.blue)
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Image.asset(urlLogo.toString()),
                ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextTheme.of(
              context,
            ).bodyLarge!.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
