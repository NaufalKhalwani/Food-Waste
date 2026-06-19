import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/controllers/beranda_controller.dart';

final TextEditingController catatanController = TextEditingController();

String? selectedPackaging;
bool isHalal = true;
bool isUrgent = true;

class PengajuanDonasiPage extends StatefulWidget {
  const PengajuanDonasiPage({super.key});
  @override
  State<PengajuanDonasiPage> createState() => _PengajuanDonasiPageState();
}

class _PengajuanDonasiPageState extends State<PengajuanDonasiPage> {
  final makananController = TextEditingController();
  final porsiController = TextEditingController();
  final dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  String? selectedCategory;
  String halalStatus = "Halal";

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          "Donasi Makanan",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Detail Makanan",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "Bantu kami mengatahui apa yang ingin Anda\nbagikan",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      custom_form_without_labeltext(
                        title: "Jenis Makanan",
                        subtitle: "Contoh: Nasi Kotak Ayam",
                        controller: makananController,
                      ),
                      SizedBox(height: 10),
                      custom_form_without_labeltext(
                        title: "Jumlah Porsi",
                        subtitle: "Contoh: 5",
                        controller: porsiController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      CustomDropdown(
                        title: "Kategori",
                        value: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status Halal",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                RadioListTile<String>(
                                  title: const Text("Halal"),
                                  value: "Halal",
                                  groupValue: halalStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      halalStatus = value!;
                                    });
                                  },
                                ),

                                RadioListTile<String>(
                                  title: const Text("Non Halal"),
                                  value: "Non Halal",
                                  groupValue: halalStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      halalStatus = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      const SizedBox(height: 15),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            "Kebutuhan Mendesak",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            isUrgent
                                ? "Perlu segera dijemput"
                                : "Tidak mendesak",
                          ),
                          value: isUrgent,
                          onChanged: (value) {
                            setState(() {
                              isUrgent = value;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 20),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () async {
                          final auth = AuthController.instance;
                          if (auth.currentUser.value == null) {
                            Get.snackbar(
                              "Error",
                              "Silakan login terlebih dahulu.",
                            );
                            return;
                          }
                          if (auth.currentUser.value!['sub_role'] !=
                              'penerima') {
                            Get.snackbar(
                              "Akses Ditolak",
                              "Hanya Penerima yang dapat mendonasikan makanan.",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          if (makananController.text.trim().isEmpty) {
                            Get.snackbar(
                              "Gagal",
                              "Nama makanan tidak boleh kosong.",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          final porsi = int.tryParse(porsiController.text);
                          if (porsi == null || porsi <= 0) {
                            Get.snackbar(
                              "Gagal",
                              "Jumlah porsi tidak valid.",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          if (selectedCategory == null) {
                            Get.snackbar(
                              "Gagal",
                              "Pilih kategori makanan.",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          // Show loading spinner

                          Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false,
                          );

                          try {
                            final url = Uri.parse(
                              '${auth.baseUrl}/api/request',
                            );
                            final body = {
                              'nama_makanan': makananController.text.trim(),
                              'jumlah': porsi,
                              'kategori': selectedCategory,
                              'kondisi_makanan': 'Baik',
                              'status_makanan': 'tersedia',
                              'halal': halalStatus == "Halal",
                              'urgent': isUrgent,
                            };

                            final response = await http.post(
                              url,
                              headers: auth.headers,
                              body: jsonEncode(body),
                            );

                            Get.back(); // close dialog

                            if (response.statusCode == 201 ||
                                response.statusCode == 200) {
                              Get.snackbar(
                                "Sukses",
                                "Ajukan donasi makanan berhasil dibuat!",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              // Refresh home page data
                              if (Get.isRegistered<BerandaController>()) {
                                BerandaController.instance.fetchFoods();
                              }
                              Get.back(); // return to previous screen
                            } else {
                              Get.snackbar(
                                "Gagal",
                                "Gagal membuat donasi: ${response.body}",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          } catch (e) {
                            Get.back(); // close dialog
                            Get.snackbar(
                              "Error",
                              "Tidak dapat menghubungi server: $e",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            const Color(0xff0F52FF),
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                            const Color(0xff0F52FF),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Ajukan Donasi",
                            style: Theme.of(context).textTheme.headlineSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String title;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: "Pilih",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          items: ["Nasi", "Minuman", "Snack"]
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class DateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const DateField({super.key, required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Batas Waktu Konsumsi",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: DateFormat('dd MMM yyyy').format(DateTime.now()),
            suffixIcon: Icon(Icons.calendar_today),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.4),
                width: 2,
              ),
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

class custom_form_without_labeltext extends StatelessWidget {
  const custom_form_without_labeltext({
    super.key,
    required this.title,
    required this.subtitle,
    this.controller,
    this.keyboardType,
  });

  final String title;
  final String subtitle;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: subtitle,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.4),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
