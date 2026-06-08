import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  Widget buildHelp({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pusat Bantuan"),
      ),

      body: ListView(
        children: [
          buildHelp(
            question: "Bagaimana cara donasi?",
            answer:
                "Pilih menu donasi lalu isi data makanan yang ingin didonasikan.",
          ),

          buildHelp(
            question: "Bagaimana makanan dikirim?",
            answer:
                "Kurir atau relawan akan mengambil makanan ke lokasi.",
          ),

          buildHelp(
            question: "Apakah donasi gratis?",
            answer:
                "Ya, seluruh proses donasi tidak dipungut biaya.",
          ),
        ],
      ),
    );
  }
}