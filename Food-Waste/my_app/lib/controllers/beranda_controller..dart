import 'package:get/get.dart';

class BerandaController extends GetxController {
  static BerandaController get instance => Get.find();

  final currentIdex = 0.obs;

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
}
