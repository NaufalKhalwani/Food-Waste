import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/beranda_controller..dart';
import 'package:my_app/pages/donasi/donasi.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  bool isNotif = true;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BerandaController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Icon(Icons.fastfood, size: 20, color: Colors.blue),
        title: Text(
          "FoodShare",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isNotif = !isNotif;
              });
            },
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded),
                if (isNotif)
                  Positioned(
                    right: 2,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 40),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getGreeting() + ", Cia!",
                        style: TextTheme.of(
                          context,
                        ).headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: "Dampak luar biasa Anda telah\nmenyelamatkan ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(text: "42,5kg "),
                            TextSpan(text: "makanan bulan ini."),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                addDonation(onTap: () => Get.to(() => DonasiPage())),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    customFiturContainer(
                      title: "Jadwal Jemput",
                      icon: Icons.calendar_month_outlined,
                    ),
                    customFiturContainer(
                      title: "Riwayat",
                      color: Colors.green,
                      icon: Icons.av_timer,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                ///
                ///Fingturs Demand
                ///
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Donasi Terdekat",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 23,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Lihat Semua",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    GridView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 kolom
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 25,
                        childAspectRatio: 0.9, // rasio kotak (lebar/tinggi)
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: Offset(0, 8),
                                blurRadius: 20,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      "https://picsum.photos/200/300?random=$index",
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Roti",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later_outlined,
                                              size: 15,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              "Sisa 2 hari",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class customFiturContainer extends StatelessWidget {
  const customFiturContainer({
    super.key,
    required this.title,
    this.color,
    required this.icon,
  });
  final String title;
  final Color? color;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.43,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          customContainerIcon(
            icon: icon,
            color: color ?? Colors.orange,
            title: title,
          ),
        ],
      ),
    );
  }
}

class customContainerIcon extends StatelessWidget {
  const customContainerIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
  });
  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.withOpacity(0.1),
          ),
          child: Icon(icon, color: color ?? Colors.blue, size: 40),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextTheme.of(
            context,
          ).bodyLarge!.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ],
    );
  }
}

class addDonation extends StatelessWidget {
  const addDonation({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.07),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.add_circle, color: Colors.white, size: 30),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Buat Donasi baru",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Berbagi makanan untuk\nmengurangi Food Waste berlebih",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 236, 236, 236),
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 45,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
