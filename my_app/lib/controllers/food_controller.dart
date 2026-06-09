import 'dart:convert';
import 'package:get/get.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/service/api_service.dart';

class FoodController extends GetxController {
  static FoodController get instance => Get.find();

  final RxList makanans = [].obs;
  final RxBool isLoading = false.obs;
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchMakanans();
  }

  Future<void> fetchMakanans() async {
    if (!_authController.isLoggedIn) return;

    isLoading.value = true;
    try {
      final response = await ApiService.getMakanans(_authController.token.value);
      if (response.statusCode == 200) {
        final List parsed = jsonDecode(response.body);
        makanans.assignAll(parsed);
      } else {
        Get.snackbar('Error', 'Gagal memuat daftar donasi makanan.');
      }
    } catch (e) {
      print('Fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createMakanan({
    required String namaMakanan,
    required String kategori,
    required int jumlah,
    required String kondisiMakanan,
    required String tanggalKadaluarsa,
    required String penyimpananId,
  }) async {
    if (!_authController.isLoggedIn) {
      Get.snackbar('Error', 'Sesi login tidak valid. Silakan login kembali.');
      return false;
    }

    isLoading.value = true;
    try {
      final response = await ApiService.createMakanan(
        token: _authController.token.value,
        namaMakanan: namaMakanan,
        kategori: kategori,
        jumlah: jumlah,
        kondisiMakanan: kondisiMakanan,
        tanggalKadaluarsa: tanggalKadaluarsa,
        penyimpananId: penyimpananId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Makanan berhasil didonasikan!',
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchMakanans(); // Refresh the list
        isLoading.value = false;
        return true;
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          'Gagal Donasi',
          data['error'] ?? 'Gagal membuat donasi makanan.',
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
}
