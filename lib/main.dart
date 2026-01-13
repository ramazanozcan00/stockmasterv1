import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // 1. EKLENDİ: Font paketi

// BU İKİ SATIR OLMAZSA HATA VERİR:
import 'package:stock_master_mobile/screens/login_screen.dart';
import 'package:stock_master_mobile/providers/auth_provider.dart';

void main() {
  // 2. EKLENDİ: Uygulama başlamadan önce font ayarını yap
  // Bu satır, internet yoksa varsayılan fontu kullanır ve ÇÖKMEYİ ENGELLER.
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Stock Master',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // 3. EKLENDİ: Tüm uygulamada modern Google Fontu (Poppins) kullan
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
