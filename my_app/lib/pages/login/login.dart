import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/beranda/beranda.dart';
import 'package:my_app/pages/register/widgets/custom_sign.dart';
import 'package:my_app/utils/validator.dart';
import 'package:my_app/widgets/custom_button_elevated.dart';
import 'package:my_app/widgets/custom_form.dart';
import 'package:my_app/widgets/custom_or.dart';
import 'package:my_app/widgets/custom_sign_text.dart';
import 'package:my_app/widgets/header_sign.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isChecked = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(238, 255, 255, 255),
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 50),
                    child: Image.asset("assets/logos/login_logo.png"),
                  ),
                  SizedBox(height: 0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(2, 2),
                          blurRadius: 0.5,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Selamat Datang",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          CustomForm(
                            title: "Email",
                            prefixIcon: Icons.email,
                            controller: emailController,
                            validator: AppValidator.email,
                          ),
                          SizedBox(height: 20),
                          CustomForm(
                            title: "Password",
                            prefixIcon: Icons.lock,
                            isPassword: true,
                            controller: passwordController,
                            validator: AppValidator.password,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,

                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 2),
                                  Text("Remember me"),
                                ],
                              ),

                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Lupa password?",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          custom_button_elevated(
                            title: "Login",
                            onTap: () => Get.to(Beranda()),
                          ),
                          SizedBox(height: 20),
                          or(
                            title:
                                "--------------- Or Sign with --------------",
                          ),
                          SizedBox(height: 20),
                          costumeGoogleSign(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  custom_sign_text(
                    title: "Belum punya akun?",
                    subtitle: " Daftar",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
