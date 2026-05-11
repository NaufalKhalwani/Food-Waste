import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/widgets/container_lokasi.dart';
import 'package:my_app/widgets/upload_foto_widget.dart';

class DonasiPage extends StatefulWidget {
  const DonasiPage({super.key});

  @override
  State<DonasiPage> createState() => _DonasiPageState();
}

class _DonasiPageState extends State<DonasiPage> {
  final makananController = TextEditingController();
  final porsiController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;
  String? selectedCategory;

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
      appBar: AppBar(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail Makanan",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
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
                  children: [
                    custom_form_without_labeltext(
                      title: "Nama Makanan",
                      subtitle: "Masukan nama lengkap sesuai KTP",
                    ),
                    SizedBox(height: 10),
                    custom_form_without_labeltext(
                      title: "Jumlah Porsi",
                      subtitle: "0",
                    ),
                    SizedBox(height: 10),
                    DateField(
                      controller: dateController,
                      onTap: () => pickDate(context),
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
                    UploadFotoWidget(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
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
          style: TextTheme.of(
            context,
          ).bodyLarge!.copyWith(fontWeight: FontWeight.w700),
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
          style: TextTheme.of(
            context,
          ).bodyLarge!.copyWith(fontWeight: FontWeight.w700),
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
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextTheme.of(
            context,
          ).bodyLarge!.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            hint: Text(subtitle),

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
