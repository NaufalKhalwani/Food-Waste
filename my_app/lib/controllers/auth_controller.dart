import 'dart:convert';
import 'package:get/get.dart';
import 'package:my_app/service/api_service.dart';
import 'package:my_app/navigation_menu.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final RxString token = ''.obs;
  final RxMap user = {}.obs;
  final RxBool isLoading = false.obs;

  bool get isLoggedIn => token.isNotEmpty;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await ApiService.registerPendonor(
        name: name,
        email: email,
        password: password,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Akun berhasil dibuat! Silakan masuk.',
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return true;
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Gagal Registrasi',
          data['error'] ?? 'Terjadi kesalahan saat membuat akun.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      // 1. Try logging in as Pendonor (donor)
      var response = await ApiService.loginPendonor(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token.value = data['token'];
        user.value = data['user'];
        Get.snackbar(
          'Sukses',
          'Selamat datang kembali, ${data['user']['nama']}!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => NavigationMenu());
        isLoading.value = false;
        return true;
      }

      // 2. Try fallback to Penerima (recipient) if pendonor login failed
      response = await ApiService.loginPenerima(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token.value = data['token'];
        user.value = data['user'];
        Get.snackbar(
          'Sukses',
          'Selamat datang kembali, ${data['user']['nama']}!',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => NavigationMenu());
        isLoading.value = false;
        return true;
      }

      // 3. Both failed
      final data = jsonDecode(response.body);
      Get.snackbar(
        'Login Gagal',
        data['error'] ?? 'Email atau password salah.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  void logout() {
    token.value = '';
    user.clear();
    Get.offAllNamed('/'); // Navigate to default route (starts at Register or Login)
  }
}
