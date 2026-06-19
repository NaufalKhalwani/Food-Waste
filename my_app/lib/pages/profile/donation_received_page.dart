import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/auth_controller.dart';

class DonationReceivedPage extends StatelessWidget {
  const DonationReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = AuthController.instance.currentUser.value;
      final subRole = user?['sub_role'] ?? 'user';
      return Scaffold(
        appBar: AppBar(title: Text("Donasi Diterima")),
        body: Builder(
          builder: (context) {
            if (subRole == 'admin') {
              return ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Paket Makanan"),
                      subtitle: Text("Menunggu verifikasi"),
                    ),
                  );
                },
              );
            }

            if (subRole == 'penerima') {
              return ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Paket Makanan"),
                      subtitle: Text("telah diterima"),
                    ),
                  );
                },
              );
            }
            if (subRole == 'pendonor') {
              return ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text("Paket Makanan"),
                      subtitle: Text("telah diterima"),
                    ),
                  );
                },
              );
            }

            return Center(child: Text("Tidak ada data"));
          },
        ),
      );
    });
  }
}
