import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BerandaController extends GetxController {
  var dataPendonor = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendonor();
  }

  Future<void> fetchPendonor() async {
    isLoading.value = true;

    final url = Uri.parse('http://10.0.2.2:8080/api/pendonor');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dataPendonor.value = jsonDecode(response.body);
      } else {
        Get.snackbar("Error", "Gagal mengambil data");
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat terhubung ke server");
    } finally {
      isLoading.value = false;
    }
  }
}