import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/pages/beranda/beranda.dart';
import 'package:my_app/pages/login/login.dart';
import 'package:my_app/pages/register/widgets/custom_forms.dart';
import 'package:my_app/pages/register/widgets/custom_sign.dart';
import 'package:my_app/utils/colors.dart';
import 'package:my_app/utils/validator.dart';
import 'package:my_app/widgets/custom_button_elevated.dart';
import 'package:my_app/widgets/custom_or.dart';
import 'package:my_app/widgets/custom_sign_text.dart';
import 'package:my_app/widgets/header_sign.dart';

import '../../widgets/custom_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isCheck = false;

  String? selectedRole;

  final List<String> roles = ['Pendonor', 'Penerima'];

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  header_sign(
                    icon: Icons.app_registration,
                    title: "Buat Akun Baru",
                    subtitle:
                        "Lengkapi detail Anda untuk bergabung\ndalam misi kami.",
                  ),

                  SizedBox(height: 32),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            floatingLabelStyle: const TextStyle(
                              color: Colors.black,
                            ),

                            prefixIcon: const Icon(
                              Icons.badge,
                              color: Colors.blue,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                                width: 2,
                              ),
                            ),

                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red),
                            ),

                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                          ),

                          items: roles.map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedRole = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        CustomForm(
                          title: "Nama",
                          prefixIcon: Icons.person,
                          controller: usernameController,
                          validator: AppValidator.username,
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
                          title: "Alamat",
                          prefixIcon: Icons.location_on,
                          controller: alamatController,
                          validator: AppValidator.alamat,
                        ),
                        SizedBox(height: 20),

                        CustomForm(
                          title: "Password",
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          controller: passwordController,
                          validator: AppValidator.password,
                        ),
                        SizedBox(height: 20),

                        CustomForm(
                          title: "Konfirmasi Password",
                          prefixIcon: Icons.verified_user_rounded,
                          isPassword: true,
                          controller: confirmPassController,
                          validator: (value) => AppValidator.confirmPassword(
                            value,
                            passwordController.text,
                          ),
                        ),

                        SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  if (!isCheck) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Harus menyetujui syarat & ketentuan",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  print("VALID ✅");
                                };
                                setState(() {
                                  isCheck = !isCheck;
                                });
                              },
                              icon: Icon(
                                isCheck
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank_sharp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 2),
                            RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text: "Dengan mendaftar, saya setuju dengan ",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 15,
                                ),

                                children: [
                                  TextSpan(
                                    text:
                                        "Syarat\n& Ketentuan serta Kebijakan Privasi.",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(height: 15),

                  Obx(() {
                    final authController = AuthController.instance;
                    return authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : custom_button_elevated(
                            title: "Buat Akun",
                            onTap: () async {
                              if (selectedRole == null) {
                                Get.snackbar(
                                  "Pilih Role",
                                  "Silakan pilih role Pendonor atau Penerima.",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              if (!isCheck) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Harus menyetujui syarat & ketentuan",
                                    ),
                                  ),
                                );
                                return;
                              }

                              final success = await authController.register(
                                nama: usernameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                alamat: alamatController.text,
                                role: selectedRole!,
                              );

                              if (success) {
                                Get.off(() => const Login());
                              }
                            },
                          );
                  }),
                  const SizedBox(height: 15),

                  or(),

                  SizedBox(height: 20),

                  costumeGoogleSign(),

                  SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => Get.off(() => const Login()),
                    child: const custom_sign_text(
                      title: "Sudah punya akun? ",
                      subtitle: "Login",
                    ),
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
