import 'package:flutter/material.dart';
import 'package:my_app/widgets/sign_up_with.dart';

class costumeGoogleSign extends StatelessWidget {
  const costumeGoogleSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SignUpWith(
          icon: 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
        ),
        SizedBox(width: 30),
        SignUpWith(icon: 'https://cdn-icons-png.flaticon.com/512/0/747.png'),
      ],
    );
  }
}