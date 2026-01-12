import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_master_mobile/providers/auth_provider.dart';
import 'package:stock_master_mobile/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Giriş yapmış kullanıcının bilgilerini al
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Master"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // ÇIKIŞ YAP VE LOGIN EKRANINA DÖN
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              "Hoşgeldin, ${user?.username ?? 'Misafir'}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Şube: ${user?.branchName ?? '-'}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Buraya ilerde sayım ekranı gelecek
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Sayıma Başla"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
