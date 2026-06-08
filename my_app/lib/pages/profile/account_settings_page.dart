import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  Widget buildTile({
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan Akun"),
      ),

      body: Column(
        children: [
          buildTile(
            icon: Icons.person,
            title: "Edit Profil",
          ),

          buildTile(
            icon: Icons.lock,
            title: "Ubah Password",
          ),

          buildTile(
            icon: Icons.notifications,
            title: "Notifikasi",
          ),

          buildTile(
            icon: Icons.logout,
            title: "Logout",
          ),
        ],
      ),
    );
  }
}