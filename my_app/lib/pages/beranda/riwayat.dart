import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final histories = [
      {"food": "Roti", "weight": "5 Kg", "date": "10 Juni 2026"},
      {"food": "Nasi Box", "weight": "12 Kg", "date": "8 Juni 2026"},
      {"food": "Sayuran", "weight": "7 Kg", "date": "5 Juni 2026"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      appBar: AppBar(
        title: const Text("Riwayat Donasi"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [const Color(0xff0F52FF), Colors.blue],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Text(
                  "Total Makanan Diselamatkan",
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 10),
                Text(
                  "42.5 Kg",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "≈ 127 Porsi Makanan",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: "18",
                  subtitle: "Donasi",
                  icon: Icons.favorite,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(title: "42.5", subtitle: "Kg", icon: Icons.eco),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            "Riwayat Terbaru",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),

          const SizedBox(height: 15),

          ...histories.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HistoryCard(
                food: item["food"]!,
                weight: item["weight"]!,
                date: item["date"]!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(subtitle),
        ],
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String food;
  final String weight;
  final String date;

  const HistoryCard({
    super.key,
    required this.food,
    required this.weight,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xff0F52FF).withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: const Color(0xff0F52FF),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(date),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(weight, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text(
                "Selesai",
                style: TextStyle(color: const Color(0xff0F52FF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
