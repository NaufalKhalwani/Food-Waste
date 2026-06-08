import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationStatusPage extends StatelessWidget {
  final String status;

  const DonationStatusPage({super.key, required this.status});

  // Koordinat lokasi donasi
  static const double latitude = -6.2615;
  static const double longitude = 106.8106;

  Future<void> openNavigation() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    String description;

    switch (status) {
      case "approved":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = "Permintaan Diterima";
        description =
            "Permintaan donasi kamu telah disetujui. Silakan ambil makanan di lokasi berikut.";
        break;

      case "rejected":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = "Donasi Ditolak";
        description = "Maaf, permintaan donasi kamu belum dapat diproses.";
        break;

      default:
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        statusText = "Menunggu Konfirmasi";
        description = "Permintaan donasi sedang ditinjau oleh pihak donor.";
    }

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text("Status Donasi"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),

          child: SingleChildScrollView(
            child: Column(
              children: [
                // STATUS CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 20, top: 10),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),

                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: statusColor.withOpacity(0.15),

                        child: Icon(statusIcon, size: 50, color: statusColor),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // DETAIL DONASI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Detail Donasi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      buildDetailRow(
                        icon: Icons.restaurant,
                        title: "Makanan",
                        value: "Nasi Box Ayam Teriyaki",
                      ),

                      buildDetailRow(
                        icon: Icons.fastfood,
                        title: "Jumlah",
                        value: "20 Porsi",
                      ),

                      buildDetailRow(
                        icon: Icons.store,
                        title: "Donatur",
                        value: "The Garden Bistro",
                      ),

                      buildDetailRow(
                        icon: Icons.location_on,
                        title: "Lokasi",
                        value: "Jakarta Selatan",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 0),

                // MAPS SECTION
                if (status == "approved")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lokasi Pengambilan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),

                          child: SizedBox(
                            height: 250,

                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: const LatLng(
                                  latitude,
                                  longitude,
                                ),
                                initialZoom: 15,
                              ),

                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                                ),

                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: const LatLng(latitude, longitude),
                                      width: 60,
                                      height: 60,

                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0F52FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: openNavigation,

                            icon: const Icon(
                              Icons.navigation,
                              color: Colors.white,
                            ),

                            label: const Text(
                              "Buka Google Maps",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  Widget buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        children: [
          Icon(icon, color: const Color(0xff0F52FF)),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
