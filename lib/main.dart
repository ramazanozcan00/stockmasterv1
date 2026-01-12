import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// BU İKİ SATIR OLMAZSA HATA VERİR:
import 'package:stock_master_mobile/screens/login_screen.dart';
import 'package:stock_master_mobile/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Artık yukarıdaki import sayesinde AuthProvider'ı tanıyor
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Stock Master',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
