import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/admin/active_donation.dart';
import 'package:my_app/pages/admin/food_verification.dart';
import 'package:my_app/pages/admin/models/dummy_data.dart';
import 'package:my_app/pages/admin/recipient.dart';
import 'package:my_app/pages/admin/food_detail.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final List<Map<String, dynamic>> pendingFoods = [
    {
      "name": "Roti Bakery",
      "donatur": "Toko Roti Sejahtera",
      "qty": "20 Paket",
      "expired": "2 Hari Lagi",
      "image": "https://picsum.photos/300?1",
    },
    {
      "name": "Nasi Box",
      "donatur": "Hotel Mawar",
      "qty": "50 Box",
      "expired": "1 Hari Lagi",
      "image": "https://picsum.photos/300?2",
    },
    {
      "name": "Buah Segar",
      "donatur": "Supermarket Fresh",
      "qty": "35 Kg",
      "expired": "3 Hari Lagi",
      "image": "https://picsum.photos/300?3",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff0F52FF),
        onPressed: () {
          Get.snackbar("Refresh", "Data berhasil diperbarui");
        },
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text("Refresh", style: TextStyle(color: Colors.white)),
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: Color(0xff0F52FF),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 5),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _headerSection(),

              const SizedBox(height: 20),

              _statisticsSection(),

              const SizedBox(height: 20),

              _menuSection(),

              const SizedBox(height: 25),

              _verificationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff0F52FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Halo Admin 👋",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Kelola donasi makanan dan penerima donasi",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _statisticsSection() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        StatCard(
          title: "Menunggu\nVerifikasi",
          value: "127",
          icon: Icons.pending_actions,
          color: Colors.orange,
          onTap: () {
            Get.to(() => const FoodVerificationPage());
          },
        ),

        StatCard(
          title: "Dipublikasi",
          value: "54",
          icon: Icons.public,
          color: Colors.green,
          onTap: () {
            Get.to(() => const ActiveDonationPage());
          },
        ),

        StatCard(
          title: "Pakan\nTernak",
          value: "18",
          icon: Icons.pets,
          color: Colors.red,
          onTap: () {
            Get.snackbar(
              "Pakan Ternak",
              "Menampilkan makanan tidak layak konsumsi",
            );
          },
        ),

        StatCard(
          title: "Penerima\nACC",
          value: "73",
          icon: Icons.people_alt,
          color: Colors.blue,
          onTap: () {
            Get.to(() => const RecipientPage());
          },
        ),
      ],
    );
  }

  Widget _menuSection() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        AdminMenuCard(
          title: "Verifikasi\nMakanan",
          icon: Icons.restaurant,
          onTap: () {
            Get.to(
              () => const FoodVerificationPage(),
              transition: Transition.rightToLeft,
            );
          },
        ),

        AdminMenuCard(
          title: "Donasi Aktif",
          icon: Icons.volunteer_activism,
          onTap: () {
            Get.to(
              () => const ActiveDonationPage(),
              transition: Transition.rightToLeft,
            );
          },
        ),

        AdminMenuCard(
          title: "Penerima\nDonasi",
          icon: Icons.people,
          onTap: () {
            Get.to(
              () => const RecipientPage(),
              transition: Transition.rightToLeft,
            );
          },
        ),

        AdminMenuCard(
          title: "Riwayat",
          icon: Icons.history,
          onTap: () {
            Get.to(
              () => const HistoryPage(),
              transition: Transition.rightToLeft,
            );
          },
        ),
      ],
    );
  }

  Widget _verificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Menunggu Verifikasi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),

        const SizedBox(height: 15),

        ListView.builder(
          itemCount: pendingFoods.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = pendingFoods[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Get.to(
                  () => FoodDetailPage(
                    food: FoodDonation(
                      id: index.toString(),
                      foodName: item['name'],
                      donor: item['donatur'],
                      expired: item['expired'],
                      quantity: int.parse(
                        item['qty'].toString().split(' ').first,
                      ),
                      status: 'pending',
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image.network(
                        item['image'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          infoRow("Donatur", item['donatur']),
                          infoRow("Jumlah", item['qty']),
                          infoRow("Expired", item['expired']),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text(
                                    "Layak Konsumsi",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: "Pakan Ternak",
                                      middleText:
                                          "Alihkan makanan menjadi pakan ternak?",
                                      textConfirm: "Ya",
                                      textCancel: "Batal",
                                      onConfirm: () {
                                        Get.back();

                                        Get.snackbar(
                                          "Dialihkan",
                                          "Masuk kategori pakan ternak",
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: const Text(
                                    "Pakan Ternak",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage {
  const HistoryPage();
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(title),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AdminMenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xff0F52FF)),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
