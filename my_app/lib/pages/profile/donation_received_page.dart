import 'package:flutter/material.dart';

class DonationReceivedPage extends StatelessWidget {
  const DonationReceivedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donasi Diterima"),
      ),

      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(12),

            child: ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),

              title: Text("Paket Makanan"),

              subtitle: Text(
                "Diterima oleh panti asuhan",
              ),
            ),
          );
        },
      ),
    );
  }
}