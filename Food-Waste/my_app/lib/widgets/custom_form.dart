import 'dart:ui';

import 'package:flutter/material.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({
    super.key,
    required this.title,
    required this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.controller,
  });

  final String? Function(String?)? validator;
  final TextEditingController? controller;

  final String title;
  final IconData prefixIcon;
  final bool isPassword;

  @override
  State<CustomForm> createState() => CustomFormState();
}

class CustomFormState extends State<CustomForm> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPassword ? !_isPasswordVisible : false,

      decoration: InputDecoration(
        labelText: widget.title,

        labelStyle: const TextStyle(fontSize: 15),
        floatingLabelStyle: const TextStyle(color: Colors.black),

        prefixIcon: Icon(widget.prefixIcon, color: Colors.blue),

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4), width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
