import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_app/pages/food_waste/food_waste_page.dart';
import 'package:my_app/pages/beranda/beranda.dart';
import 'package:my_app/pages/admin/admin_dashboard.dart';
import 'package:my_app/pages/profile/profile.dart';

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});

  final controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=> AdminDashboardPage());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.admin_panel_settings, color: Colors.white),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: ClipRRect(
              child: NavigationBar(
                height: 80,
                elevation: 0,
                indicatorColor: Colors.transparent,
                selectedIndex: controller.selectedIndex.value,
                backgroundColor: Colors.white,
                onDestinationSelected: (index) =>
                    controller.selectedIndex.value = index,
                labelTextStyle: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    );
                  }
                  return const TextStyle(color: Colors.grey);
                }),
                destinations: [
                  NavigationDestination(
                    icon: Icon(
                      Iconsax.home,
                      color: controller.selectedIndex.value == 0
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    label: "Home",
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.eco,
                      color: controller.selectedIndex.value == 1
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    label: "Food Waste",
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Iconsax.user,
                      color: controller.selectedIndex.value == 2
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [Beranda(), FoodWastePage(), Profile()];
}
