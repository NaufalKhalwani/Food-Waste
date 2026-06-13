import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/Routes/routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();

  var currentUser = Rxn<Map<String, dynamic>>();
  var token = RxnString();
  var isLoading = false.obs;

  bool get isLoggedIn => token.value != null && currentUser.value != null;

  // Dynamic host based on platform
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    try {
      if (Platform.isAndroid) {
        // Android emulator's loopback interface mapping to 127.0.0.1 on the host
        return 'http://10.0.2.2:8080';
      }
    } catch (_) {}
    return 'http://localhost:8080';
  }

  String get userRole {
    final user = currentUser.value;
    if (user == null) return 'unknown';
    return (user['sub_role'] ?? 'unknown').toString().toLowerCase();
  }

  bool get isPendonor => userRole == 'pendonor';
  bool get isPenerima => userRole == 'penerima';

  // Ubah method ini saja, sisanya tetap
  void redirectByRole() {
    try {
      print('>>> REDIRECT | ROLE: $userRole');
      Get.offAllNamed('/dashboard'); // semua role ke 1 route
    } catch (e) {
      print('>>> ERROR REDIRECT: $e');
      Get.snackbar(
        'Error Navigasi',
        'Gagal berpindah halaman: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Map<String, String> get headers {
    final map = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token.value != null) {
      map['Authorization'] = 'Bearer ${token.value}';
    }
    return map;
  }

  // Register user (Pendonor / Penerima)
  Future<bool> register({
    required String nama,
    required String email,
    required String password,
    required String alamat,
    required String role, // "Pendonor" or "Penerima"
  }) async {
    isLoading.value = true;
    final isPendonor = role.toLowerCase() == 'pendonor';
    final path = isPendonor
        ? '/api/Register/pendonor'
        : '/api/Register/penerima';
    final url = Uri.parse('$baseUrl$path');

    final body = isPendonor
        ? {
            'nama_pendonor': nama,
            'email_pendonor': email,
            'password': password,
            'alamat_pendonor': alamat,
            'role': 'pendonor',
          }
        : {
            'nama_penerima': nama,
            'email': email, // JSON tag is "email" for EmailPenerima
            'password': password,
            'alamat': alamat,
            'nomor_telfon': '08123456789', // Default mock phone
            'role': 'penerima',
          };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Sukses',
          'Pendaftaran berhasil. Silakan login.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        final errorMsg = _parseError(response.body);
        Get.snackbar(
          'Gagal Mendaftar',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server backend.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login user by trying pendonor first, then penerima, then admin
  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    final credentials = {'email': email, 'password': password};

    // 1. Try logging in as Pendonor
    final successPendonor = await _tryLoginPath(
      '/api/Login/pendonor',
      credentials,
    );
    if (successPendonor) {
      isLoading.value = false;
      return true;
    }

    // 2. Try logging in as Penerima
    final successPenerima = await _tryLoginPath(
      '/api/Login/penerima',
      credentials,
    );
    if (successPenerima) {
      isLoading.value = false;
      return true;
    }

    // 3. Try logging in as Admin
    final successAdmin = await _tryLoginPath('/api/Login/admin', credentials);
    if (successAdmin) {
      isLoading.value = false;
      return true;
    }

    // All failed
    Get.snackbar(
      'Gagal Login',
      'Email atau password salah / akun tidak ditemukan.',
      snackPosition: SnackPosition.BOTTOM,
    );
    isLoading.value = false;
    return false;
  }

  Future<bool> _tryLoginPath(String path, Map<String, String> body) async {
    final url = Uri.parse('$baseUrl$path');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      print('>>> PATH: $path | STATUS: ${response.statusCode}');
      print('>>> RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token.value = data['token'];
        currentUser.value = Map<String, dynamic>.from(data['user']);
        print('>>> USER: ${currentUser.value}');
        return true;
      }
    } catch (_) {
      // Fail silently, go to next path
    }
    return false;
  }

  void logout() {
    currentUser.value = null;
    token.value = null;
    Get.snackbar(
      'Logout',
      'Anda telah keluar.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _parseError(String body) {
    try {
      final json = jsonDecode(body);
      return json['error'] ?? 'Terjadi kesalahan sistem';
    } catch (_) {
      return 'Terjadi kesalahan sistem';
    }
  }
}
