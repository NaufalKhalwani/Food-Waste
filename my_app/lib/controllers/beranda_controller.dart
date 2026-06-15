import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/controllers/auth_controller.dart';

class BerandaController extends GetxController {
  static BerandaController get instance => Get.find<BerandaController>();

  final currentIdex = 0.obs;
  var foods = <dynamic>[].obs;
  var isLoadingFoods = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFoods();
  }

  void updatePageIndicator(index) => currentIdex.value = index;

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Selamat pagi";
    } else if (hour >= 12 && hour < 15) {
      return "Selamat siang";
    } else if (hour >= 15 && hour < 18) {
      return "Selamat sore";
    } else {
      return "Selamat malam";
    }
  }

  Future<void> fetchFoods() async {
    isLoadingFoods.value = true;
    final authController = AuthController.instance;
    final url = Uri.parse('${authController.baseUrl}/api/makanan');

    try {
      final response = await http.get(
        url,
        headers: authController.headers,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          foods.value = decoded;
        }
      } else {
        // Silent fail, or log it
        print("Gagal mengambil data makanan: ${response.statusCode}");
      }
    } catch (e) {
      print("Error mengambil data makanan: $e");
    } finally {
      isLoadingFoods.value = false;
    }
  }
}
