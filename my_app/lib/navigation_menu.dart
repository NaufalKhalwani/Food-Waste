import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/pages/food_waste/food_waste_page.dart';
import 'package:my_app/pages/beranda/pendonor_dashboard.dart';
import 'package:my_app/pages/beranda/penerima_dashboard.dart';
import 'package:my_app/pages/admin/admin_dashboard.dart';
import 'package:my_app/pages/profile/profile.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.instance;

    return Obx(() {
      final role = auth.userRole;

      // Tunggu sampai role siap
      if (role == 'unknown' || role.isEmpty) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final controller = Get.put(NavigationController(role: role), tag: role);

      return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        floatingActionButton: role == 'admin'
            ? FloatingActionButton(
                onPressed: () => Get.to(() => AdminDashboardPage()),
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                ),
              )
            : null,
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: NavigationBar(
              height: 80,
              elevation: 0,
              indicatorColor: Colors.transparent,
              selectedIndex: controller.selectedIndex.value,
              backgroundColor: Colors.white,
              onDestinationSelected: (index) =>
                  controller.selectedIndex.value = index,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  );
                }
                return const TextStyle(color: Colors.grey);
              }),
              destinations: controller.destinations(
                controller.selectedIndex.value,
              ),
            ),
          ),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
      );
    });
  }
}

class NavigationController extends GetxController {
  final String role;
  NavigationController({required this.role});

  final Rx<int> selectedIndex = 0.obs;

  List<Widget> get screens {
    switch (role) {
      case 'pendonor':
        return [PendonorDashboard(), FoodWastePage(), Profile()];
      case 'penerima':
        return [PenerimaDashboard(), FoodWastePage(), Profile()];
      case 'admin':
        return [AdminDashboardPage(), FoodWastePage(), Profile()];
      default:
        return [PendonorDashboard(), FoodWastePage(), Profile()];
    }
  }

  List<NavigationDestination> destinations(int selected) {
    return _tabsForRole().asMap().entries.map((entry) {
      final i = entry.key;
      final tab = entry.value;
      return NavigationDestination(
        icon: Icon(
          tab['icon'] as IconData,
          color: selected == i ? Colors.blue : Colors.grey,
        ),
        label: tab['label'] as String,
      );
    }).toList();
  }

  List<Map<String, dynamic>> _tabsForRole() {
    switch (role) {
      case 'pendonor':
        return [
          {'icon': Iconsax.home, 'label': 'Beranda'},
          {'icon': Icons.eco, 'label': 'Food Waste'},
          {'icon': Iconsax.user, 'label': 'Profile'},
        ];
      case 'penerima':
        return [
          {'icon': Iconsax.home, 'label': 'Beranda'},
          {'icon': Icons.eco, 'label': 'Food Waste'},
          {'icon': Iconsax.user, 'label': 'Profile'},
        ];
      case 'admin':
        return [
          {'icon': Icons.dashboard, 'label': 'Dashboard'},
          {'icon': Icons.eco, 'label': 'Food Waste'},
          {'icon': Iconsax.user, 'label': 'Profile'},
        ];
      default:
        return [
          {'icon': Iconsax.home, 'label': 'Beranda'},
          {'icon': Icons.eco, 'label': 'Food Waste'},
          {'icon': Iconsax.user, 'label': 'Profile'},
        ];
    }
  }
}
