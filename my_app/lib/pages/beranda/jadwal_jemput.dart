import 'package:flutter/material.dart';

class JadwalJemputPage extends StatelessWidget {
  const JadwalJemputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = [
      {
        "food": "Roti Tawar",
        "date": "12 Juni 2026",
        "time": "14:00 WIB",
        "address": "Jl. Ahmad Yani No.20",
        "status": "Menunggu",
      },
      {
        "food": "Nasi Box",
        "date": "13 Juni 2026",
        "time": "09:00 WIB",
        "address": "Jl. Merdeka No.10",
        "status": "Diproses",
      },
      {
        "food": "Buah Segar",
        "date": "14 Juni 2026",
        "time": "15:00 WIB",
        "address": "Jl. Sudirman No.5",
        "status": "Selesai",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),

      appBar: AppBar(
        title: const Text("Jadwal Jemput"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [const Color(0xff0F52FF), Color(0xff42A5F5)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jadwal Aktif",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  "3 Penjemputan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 5),
                Text("Minggu ini", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip("Semua", true),
                _filterChip("Hari Ini", false),
                _filterChip("Besok", false),
                _filterChip("Minggu Ini", false),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ...schedules.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: PickupCard(
                food: item["food"]!,
                date: item["date"]!,
                time: item["time"]!,
                address: item["address"]!,
                status: item["status"]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _filterChip(String title, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(label: Text(title), selected: selected),
    );
  }
}

class PickupCard extends StatelessWidget {
  final String food;
  final String date;
  final String time;
  final String address;
  final String status;

  const PickupCard({
    super.key,
    required this.food,
    required this.date,
    required this.time,
    required this.address,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case "Menunggu":
        return Colors.orange;
      case "Diproses":
        return Colors.blue;
      case "Selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            food,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              const Icon(Icons.calendar_month, size: 18),
              const SizedBox(width: 8),
              Text(date),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text(time),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(address)),
            ],
          ),

          const SizedBox(height: 15),

          Chip(
            label: Text(status),
            backgroundColor: statusColor.withOpacity(.15),
            labelStyle: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
