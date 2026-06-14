import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/pages/login/login.dart';
import 'package:my_app/pages/profile/account_settings_page.dart';
import 'package:my_app/pages/profile/donation_history_page.dart';
import 'package:my_app/pages/profile/donation_received_page.dart';
import 'package:my_app/pages/profile/help_center_page.dart';
import 'package:my_app/pages/profile/saved_food_page.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.instance;

    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 40,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0F52FF), Color(0xff3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
                child: Obx(() {
                  final user = auth.currentUser.value;
                  final userName = user?['nama'] ?? 'User';
                  final subRole = user?['sub_role'] ?? 'user';
                  String roleLabel;
                  if (subRole == 'pendonor') {
                    roleLabel = 'Food Donor Partner';
                  } else if (subRole == 'penerima') {
                    roleLabel = 'Food Recipient';
                  } else if (subRole == 'admin') {
                    roleLabel = 'Administrator';
                  } else {
                    roleLabel = 'User';
                  }
                
                  return Column(
                    children: [
                      const SizedBox(height: 28),
                
                      // PROFILE IMAGE
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white,
                          child: Icon(
                            subRole == 'admin' ? Icons.admin_panel_settings : Icons.restaurant,
                            size: 50,
                            color: const Color(0xff0F52FF),
                          ),
                        ),
                      ),
                
                      const SizedBox(height: 18),
                
                      // NAME
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                
                      const SizedBox(height: 6),
                
                      Text(
                        roleLabel,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                
                      const SizedBox(height: 30),
                
                      // STATS
                      Row(
                        children: [
                          const Expanded(
                            child: ProfileStatCard(
                              icon: Icons.eco_outlined,
                              value: "340 Kg",
                              label: "Sisa Makanan\nDiselamatkan",
                            ),
                          ),
                
                          const SizedBox(width: 16),
                
                          const Expanded(
                            child: ProfileStatCard(
                              icon: Icons.favorite_outline,
                              value: "128",
                              label: "Donasi\nDiterima",
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            

            const SizedBox(height: 24),

            // =========================================
            // MENU
            // =========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.history,
                    title: "Riwayat Donasi",
                    subtitle:
                        "Lihat semua riwayat donasi makanan yang telah diberikan",
                    onTap: () {
                      Get.to(() => DonationHistoryPage());
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.fastfood_outlined,
                    title: "Makanan Terselamatkan",
                    subtitle:
                        "Pantau total sisa makanan yang berhasil disalurkan",
                    onTap: () {
                      Get.to(() => SavedFoodPage());
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.groups_outlined,
                    title: "Donasi Diterima",
                    subtitle:
                        "Lihat jumlah donasi yang diterima penerima manfaat",
                    onTap: () {
                      Get.to(() => DonationReceivedPage());
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: "Pengaturan Akun",
                    subtitle: "Kelola informasi akun dan preferensi aplikasi",
                    onTap: () {
                      Get.to(() => AccountSettingsPage());
                    },
                  ),

                  ProfileMenuItem(
                    icon: Icons.support_agent_outlined,
                    title: "Pusat Bantuan",
                    subtitle: "Butuh bantuan? Hubungi kami atau lihat FAQ",
                    onTap: () {
                      Get.to(() => HelpCenterPage());
                    },
                  ),

                  // LOGOUT BUTTON
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: "Keluar",
                    subtitle: "Keluar dari akun Anda",
                    onTap: () {
                      Get.defaultDialog(
                        title: "Konfirmasi Logout",
                        middleText: "Apakah Anda yakin ingin keluar?",
                        textConfirm: "Ya, Keluar",
                        textCancel: "Batal",
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        onConfirm: () {
                          auth.logout();
                          Get.offAll(() => const Login());
                        },
                      );
                    },
                  ),

                SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================
// REUSABLE WIDGET
// =========================================

class ProfileStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Icon(icon, color: Colors.white),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xffEEF4FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 30, color: const Color(0xff0F52FF)),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff111827),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
