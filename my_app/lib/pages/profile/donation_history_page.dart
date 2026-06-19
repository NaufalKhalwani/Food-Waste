import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/donasi/donasi.dart';

class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: Get.back,
                    child: const Icon(Icons.arrow_back_ios_new, size: 28),
                  ),
                  SizedBox(width: 15),
                  const Text(
                    "Dashboard Donatur",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Ringkasan Dampak",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Kontribusi Anda telah menciptakan perubahan nyata.",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.off(() => DonasiPage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    "Donasi Sekarang",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              _buildStatCard(
                title: "TOTAL DONASI",
                value: "450",
                unit: "kg",
                subtitle: "75% dari target bulan ini",
                icon: Icons.scale_outlined,
                color: Colors.blue,
                progress: 0.75,
              ),

              const SizedBox(height: 20),

              _buildStatCard(
                title: "DAMPAK SOSIAL",
                value: "1.2k",
                unit: "Orang",
                subtitle: "Penerima manfaat di 12 titik distribusi.",
                icon: Icons.groups_outlined,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              _buildStatCard(
                title: "PENGURANGAN EMISI",
                value: "85",
                unit: "kg CO2",
                subtitle: "Setara dengan menanam 4 pohon dewasa.",
                icon: Icons.eco_outlined,
                color: Colors.green,
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Donasi Aktif",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Lihat Semua",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _activeDonationCard(),
                    const SizedBox(width: 16),
                    _activeDonationCard(),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Aktivitas Terakhir",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              _historyTile(),
              _historyTile(),
              _historyTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required String subtitle,
    required IconData icon,
    required Color color,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: value,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: " $unit",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 15),

          if (progress != null)
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: Colors.blue,
            ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeDonationCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Paket Sayuran Segar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 10),
          Text("Pick-up : 14:00 WIB"),
          Spacer(),
          LinearProgressIndicator(value: .6, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _historyTile() {
    return const ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.check_circle_outline, color: Colors.blue),
      ),
      title: Text("Roti & Pastry"),
      subtitle: Text("24 Mar 2024"),
      trailing: Text(
        "SELESAI",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}
