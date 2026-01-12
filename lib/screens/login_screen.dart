import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stock_master_mobile/providers/auth_provider.dart';
import 'package:stock_master_mobile/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form kontrolü için anahtarlar
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Şifre gizle/göster durumu
  bool _isLoading = false; // Yükleniyor animasyonu için

  // GİRİŞ YAP BUTONU (ARTIK GERÇEK)
  void _login() async {
    // 1. Validasyon Kontrolü (Boş mu?)
    if (_formKey.currentState!.validate()) {
      // Klavyeyi kapat (UX için önemli)
      FocusScope.of(context).unfocus();

      setState(() {
        _isLoading = true;
      });

      try {
        // 2. PROVIDER'A EMRİ VER: "Giriş Yap!"
        // listen: false diyoruz çünkü burada UI güncellemiyoruz, sadece fonksiyon çağırıyoruz.
        await Provider.of<AuthProvider>(context, listen: false).login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        // 3. BAŞARILI İSE BURAYA DÜŞER -> ANA SAYFAYA GİT
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        // 4. HATA VARSA (Şifre yanlış vs.) -> UYARI GÖSTER
        if (mounted) {
          // Hata mesajındaki gereksiz "Exception:" yazısını temizle
          String errorMessage =
              e.toString().replaceAll('Exception:', '').trim();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text(errorMessage)),
                ],
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating, // Yüzen snackbar daha şık
            ),
          );
        }
      } finally {
        // 5. HER DURUMDA YÜKLENİYORU DURDUR
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Web arka plan rengi
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. LOGO VE BAŞLIK
              const Icon(Icons.inventory_2_outlined,
                  size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                "STOCK MASTER",
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2C3E50),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Depo Yönetim Sistemi",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // 2. GİRİŞ KARTI
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // KULLANICI ADI
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Kullanıcı Adı",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen kullanıcı adı girin';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // ŞİFRE
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible, // Şifreyi gizle
                          decoration: InputDecoration(
                            labelText: "Şifre",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen şifre girin';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // GİRİŞ BUTONU
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Giriş Yap",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                "v1.0.0",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
