import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:my_app/pages/admin/food_detail.dart';
import 'package:my_app/pages/admin/models/dummy_data.dart';

class FoodVerificationPage extends StatelessWidget {
  const FoodVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = dummyFoods.where((e) => e.status == 'pending').toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi Makanan")),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: pending.length,
        itemBuilder: (context, index) {
          final food = pending[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.fastfood)),
              title: Text(food.foodName),
              subtitle: Text(food.donor),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.to(() => FoodDetailPage(food: food));
              },
            ),
          );
        },
      ),
    );
  }
}
