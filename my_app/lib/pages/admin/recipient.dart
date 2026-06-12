import 'package:flutter/material.dart';

class RecipientPage extends StatelessWidget {
  const RecipientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Penerima Donasi")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          recipientCard(
            "Panti Asuhan Harapan",
            "25 Anak",
          ),

          recipientCard(
            "Yayasan Berkah",
            "40 Penerima",
          ),
        ],
      ),
    );
  }

  Widget recipientCard(
    String name,
    String total,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.people),
              ),
              title: Text(name),
              subtitle: Text(total),
            ),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("ACC"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Tolak"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}