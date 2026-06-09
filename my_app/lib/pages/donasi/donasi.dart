import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/widgets/container_lokasi.dart';
import 'package:my_app/widgets/upload_foto_widget.dart';
import 'package:my_app/controllers/food_controller.dart';

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

  Position? currentPosition;
  String lokasiText = "Ambil lokasi penjemputan";
  double? latitude;
  double? longitude;

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

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Get.snackbar("Lokasi", "Aktifkan GPS terlebih dahulu");
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Lokasi", "Izin lokasi ditolak permanen");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;

    setState(() {
      currentPosition = position;

      latitude = position.latitude;
      longitude = position.longitude;

      lokasiText = "${place.street}, ${place.subLocality}, ${place.locality}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodController = FoodController.instance;
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
                      UploadFotoWidget(),
                      SizedBox(height: 10),
                      custom_form_without_labeltext(
                        title: "Nama Makanan",
                        subtitle: "Masukan nama makanan",
                        controller: makananController,
                      ),
                      SizedBox(height: 10),
                      custom_form_without_labeltext(
                        title: "Jumlah Porsi",
                        subtitle: "0",
                        controller: porsiController,
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
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Lokasi Penjemputan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xff0F52FF),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    lokasiText,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            SizedBox(
                              width: double.infinity,

                              child: ElevatedButton.icon(
                                onPressed: getCurrentLocation,

                                icon: const Icon(
                                  Icons.my_location,
                                  color: const Color(0xff0F52FF),
                                ),

                                label: const Text(
                                  "Gunakan Lokasi Saat Ini",
                                  style: TextStyle(
                                    color: const Color(0xff0F52FF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => foodController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () async {
                                  if (makananController.text.trim().isEmpty) {
                                    Get.snackbar(
                                      "Validasi",
                                      "Nama makanan tidak boleh kosong",
                                    );
                                    return;
                                  }
                                  if (porsiController.text.trim().isEmpty) {
                                    Get.snackbar(
                                      "Validasi",
                                      "Jumlah porsi tidak boleh kosong",
                                    );
                                    return;
                                  }
                                  final expiry =
                                      selectedDate ??
                                      DateTime.now().add(
                                        const Duration(days: 1),
                                      );
                                  final success = await foodController
                                      .createMakanan(
                                        namaMakanan: makananController.text
                                            .trim(),
                                        kategori: selectedCategory ?? "Nasi",
                                        jumlah:
                                            int.tryParse(
                                              porsiController.text.trim(),
                                            ) ??
                                            1,
                                        kondisiMakanan: "Sangat Baik",
                                        tanggalKadaluarsa: expiry
                                            .toUtc()
                                            .toIso8601String(),
                                        penyimpananId: lokasiText,
                                      );
                                  if (success) {
                                    Get.back();
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Donasi",
                                    style: TextTheme.of(context).headlineSmall!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
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
    this.controller,
  });

  final String title;
  final String subtitle;
  final TextEditingController? controller;

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
          controller: controller,
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
