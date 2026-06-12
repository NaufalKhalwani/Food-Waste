import 'package:flutter/material.dart';
import 'package:my_app/pages/admin/models/dummy_data.dart';

class ActiveDonationPage extends StatelessWidget {
  const ActiveDonationPage({super.key});

  @override
  Widget build(BuildContext context) {

    final published =
        dummyFoods.where((e) => e.status == "published").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donasi Aktif"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: published.length,
        itemBuilder: (_, index) {

          final item = published[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fastfood,
                  size: 40,
                ),
                const SizedBox(height: 10),
                Text(item.foodName),
                Text(
                  "${item.quantity} Paket",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}