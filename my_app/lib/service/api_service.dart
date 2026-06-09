import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static String get baseUrl {
    if (GetPlatform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  static Future<http.Response> registerPendonor({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/Register/pendonor');
    final body = jsonEncode({
      'nama_pendonor': name,
      'email_pendonor': email,
      'password': password,
      'alamat_pendonor': '',
    });

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> loginPendonor({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/Login/pendonor');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> loginPenerima({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/Login/penerima');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  }

  static Future<http.Response> getMakanans(String token) async {
    final url = Uri.parse('$baseUrl/api/makanan');
    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> createMakanan({
    required String token,
    required String namaMakanan,
    required String kategori,
    required int jumlah,
    required String kondisiMakanan,
    required String tanggalKadaluarsa,
    required String penyimpananId,
  }) async {
    final url = Uri.parse('$baseUrl/api/makanan');
    final body = jsonEncode({
      'nama_makanan': namaMakanan,
      'kategori': kategori,
      'jumlah': jumlah,
      'kondisi_makanan': kondisiMakanan,
      'status_makanan': 'tersedia',
      'tanggal_kadaluarsa': tanggalKadaluarsa,
      'penyimpanan_id': penyimpananId,
      'foto_makanan': null, // opsional/null
    });

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
  }
}