import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:my_app/pages/admin/models/dummy_data.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodDonation food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.foodName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 80,
                ),
              ),
            ),

            const SizedBox(height: 20),

            info("Donatur", food.donor),
            info("Jumlah", "${food.quantity} Paket"),
            info("Expired", food.expired),

            const Spacer(),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(
                        double.infinity,
                        55,
                      ),
                    ),
                    onPressed: () {
                      Get.snackbar(
                        "Berhasil",
                        "Makanan dipublikasikan",
                      );
                    },
                    icon: const Icon(Icons.check),
                    label: const Text(
                      "Layak Konsumsi",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(
                        double.infinity,
                        55,
                      ),
                    ),
                    onPressed: () {
                      Get.snackbar(
                        "Dialihkan",
                        "Menjadi pakan ternak",
                      );
                    },
                    icon: const Icon(Icons.pets),
                    label: const Text(
                      "Pakan Ternak",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget info(
    String title,
    String value,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}