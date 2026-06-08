import 'package:flutter/material.dart';

class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Donasi"),
      ),

      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              leading: Icon(
                Icons.food_bank,
                color: Colors.green,
              ),

              title: Text("Donasi Nasi Box"),

              subtitle: Text(
                "20 Mei 2026 • Berhasil didonasikan",
              ),
            ),
          );
        },
      ),
    );
  }
}