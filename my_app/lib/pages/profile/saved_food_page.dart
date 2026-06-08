import 'package:flutter/material.dart';

class SavedFoodPage extends StatelessWidget {
  const SavedFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Makanan Terselamatkan"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 80,
              color: Colors.green,
            ),

            SizedBox(height: 20),

            Text(
              "125 Kg",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Makanan berhasil diselamatkan",
            ),
          ],
        ),
      ),
    );
  }
}