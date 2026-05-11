import 'dart:ui';

import 'package:flutter/material.dart';

class or extends StatelessWidget {
  const or({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          title ?? "------------------- OR --------------------",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
