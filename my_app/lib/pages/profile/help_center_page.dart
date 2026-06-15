import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/auth_controller.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  Widget buildHelp({
    required String question,
    required String answer,
    void Function()? onTap,
  }) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(padding: const EdgeInsets.all(16), child: Text(answer)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = AuthController.instance.currentUser.value;
      final subRole = user?['sub_role'] ?? 'user';
      return Scaffold(
        appBar: AppBar(title: Text("Pusat Bantuan")),

        body: ListView(
          children: [
            if (subRole == 'pendonor') ...[
              buildHelp(
                onTap: () {},
                question: "Bagaimana cara donasi?",
                answer:
                    "Pilih menu donasi lalu isi data makanan yang ingin didonasikan.",
              ),

              buildHelp(
                onTap: () {},
                question: "Bagaimana makanan dikirim?",
                answer: "Kurir atau relawan akan mengambil makanan ke lokasi.",
              ),

              buildHelp(
                onTap: () {},
                question: "Apakah donasi gratis?",
                answer: "Ya, seluruh proses donasi tidak dipungut biaya.",
              ),
            ],
            if (subRole == 'penerima') ...[
              buildHelp(
                onTap: () {},
                question: "Bagaimana cara menerima donasi?",
                answer:
                    "Pilih menu menerima donasi lalu isi data makanan yang ingin diterima.",
              ),

              buildHelp(
                onTap: () {},
                question: "Bagaimana makanan dikirim?",
                answer: "Kurir atau relawan akan mengambil makanan ke lokasi.",
              ),

              buildHelp(
                onTap: () {},
                question: "Apakah menerima donasi gratis?",
                answer:
                    "Ya, seluruh proses menerima donasi tidak dipungut biaya.",
              ),
            ],
            if (subRole == 'admin') ...[
              buildHelp(
                onTap: () {},
                question: "Bagaimana cara donasi?",
                answer:
                    "Pilih menu donasi lalu isi data makanan yang ingin didonasikan.",
              ),

              buildHelp(
                onTap: () {},
                question: "Bagaimana makanan dikirim?",
                answer: "Kurir atau relawan akan mengambil makanan ke lokasi.",
              ),

              buildHelp(
                onTap: () {},
                question: "Apakah donasi gratis?",
                answer: "Ya, seluruh proses donasi tidak dipungut biaya.",
              ),
            ],
          ],
        ),
      );
    });
  }
}
