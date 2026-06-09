import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/food_waste/donation_status_page.dart';
import 'package:my_app/controllers/food_controller.dart';

class FoodWastePage extends StatelessWidget {
  const FoodWastePage({super.key});

  @override
  Widget build(BuildContext context) {
    final foodController = FoodController.instance;

    String formatSisaHari(String? dateStr) {
      if (dateStr == null) return "Sisa 1 hari";
      try {
        final expiry = DateTime.parse(dateStr);
        final diff = expiry.difference(DateTime.now());
        if (diff.inDays > 0) {
          return "Sisa ${diff.inDays} hari";
        } else if (diff.inHours > 0) {
          return "Sisa ${diff.inHours} jam";
        } else if (diff.inMinutes > 0) {
          return "Sisa ${diff.inMinutes} menit";
        } else {
          return "Kadaluarsa";
        }
      } catch (_) {
        return "Sisa 1 hari";
      }
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff0F52FF),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xffF4F7FB),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // =====================================
                // HEADER
                // =====================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff0F52FF), Color(0xff3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Text(
                        "Food Waste Rescue",
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Temukan makanan layak konsumsi yang siap didonasikan",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(color: Colors.white70),
                      ),

                      const SizedBox(height: 24),

                      // SEARCH
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),

                            const SizedBox(width: 12),

                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Cari makanan atau lokasi...",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================
                // CATEGORY
                // =====================================
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: const [
                      FoodCategoryChip(title: "Semua", isSelected: true),
                      FoodCategoryChip(title: "Nasi"),
                      FoodCategoryChip(title: "Roti"),
                      FoodCategoryChip(title: "Minuman"),
                      FoodCategoryChip(title: "Sayur"),
                      FoodCategoryChip(title: "Dessert"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================
                // FOOD LIST
                // =====================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () {
                      if (foodController.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      if (foodController.makanans.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: Text(
                              "Belum ada makanan layak konsumsi yang didonasikan.",
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: foodController.makanans.map((item) {
                          final int index = foodController.makanans.indexOf(item);
                          final name = item['nama_makanan'] ?? 'Makanan';
                          final sisa = formatSisaHari(item['tanggal_kadaluarsa']);
                          final jumlah = "${item['jumlah'] ?? 0} Porsi";
                          final lokasi = item['penyimpanan_id'] ?? 'Lokasi';

                          return FoodDonationCard(
                            onPress: () => Get.to(
                              () => const DonationStatusPage(status: "approved"),
                            ),
                            donorName: "Food Share Donor",
                            foodName: name,
                            portion: jumlah,
                            distance: "1.5 Km",
                            timeLeft: sisa,
                            location: lokasi,
                            statusColor: const Color(0xff22C55E),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================
// CATEGORY CHIP
// =====================================

class FoodCategoryChip extends StatelessWidget {
  final String title;
  final bool isSelected;

  const FoodCategoryChip({
    super.key,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xff0F52FF) : Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// =====================================
// FOOD DONATION CARD
// =====================================

class FoodDonationCard extends StatelessWidget {
  final String donorName;
  final String foodName;
  final String portion;
  final String distance;
  final String timeLeft;
  final String location;
  final Color statusColor;
  final VoidCallback? onPress;

  const FoodDonationCard({
    super.key,
    required this.donorName,
    required this.foodName,
    required this.portion,
    required this.distance,
    required this.timeLeft,
    required this.location,
    required this.statusColor,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xffEEF4FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Color(0xff0F52FF),
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donorName,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      location,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  timeLeft,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // FOOD NAME
          Text(
            foodName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // INFO
          Row(
            children: [
              const Icon(Icons.fastfood_outlined, size: 18, color: Colors.grey),

              const SizedBox(width: 6),

              Text(portion, style: TextStyle(color: Colors.grey.shade700)),

              const SizedBox(width: 18),

              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 6),

              Text(distance, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),

          const SizedBox(height: 20),

          // BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0F52FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: onPress,
              child: const Text(
                "Ajukan Donasi",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
