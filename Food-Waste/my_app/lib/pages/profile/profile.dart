import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sistem Anti Food Waste",
              style: TextTheme.of(context).headlineLarge!.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "THE GARDEN BISTRO",
              style: TextTheme.of(context).bodyLarge!.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        ],
      ),
    );
  }
}
