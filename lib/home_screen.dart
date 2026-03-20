import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: const Color(0xffE53935),
        title: const Text("SocioHub"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [

            buildCard(Icons.people, "Visitors", () {
              // Navigate to Visitor Screen
            }),

            buildCard(Icons.notifications, "Notice Board", () {
              // Navigate to Notice Screen
            }),

            buildCard(Icons.payment, "Payments", () {
              // Navigate to Payment Screen
            }),

            buildCard(Icons.person, "Profile", () {
              // Navigate to Profile Screen
            }),
          ],
        ),
      ),
    );
  }

  Widget buildCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(icon, size: 50, color: const Color(0xffE53935)),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )

          ],
        ),
      ),
    );
  }
}
