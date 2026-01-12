import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // debugPrint için
import 'package:stock_master_mobile/core/constants.dart';
import 'package:stock_master_mobile/models/user_model.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<User?> login(String username, String password) async {
    // URL'i konsola yazdıralım ki doğru yere mi gidiyor görelim
    final String url = '${Constants.baseUrl}/AuthApi/Login';
    debugPrint("İSTEK GÖNDERİLİYOR: $url");

    try {
      final response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.plain, // Ham veri istiyoruz
          validateStatus: (status) =>
              true, // Hata olsa bile throw yapma, ben kontrol edeceğim
        ),
      );

      debugPrint("SUNUCU YANITI KODU: ${response.statusCode}");
      debugPrint("SUNUCU YANITI VERİSİ: ${response.data}");

      // 1. BAŞARILI DURUM (200 OK)
      if (response.statusCode == 200) {
        dynamic responseData = response.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }
        return User.fromJson(responseData);
      }

      // 2. HATALI DURUM (400, 401, 404, 500 vb.)
      else {
        String errorMessage = "Sunucu Hatası (${response.statusCode})";

        // Gelen veri dolu mu boş mu?
        if (response.data != null && response.data.toString().isNotEmpty) {
          try {
            // Belki JSON formatındadır
            var errorJson = jsonDecode(response.data.toString());
            if (errorJson is Map && errorJson.containsKey('message')) {
              errorMessage = errorJson['message'];
            }
          } catch (_) {
            // JSON değilse (HTML vs.) ve kısaysa direkt göster
            String rawData = response.data.toString();
            if (rawData.length < 100) {
              errorMessage = rawData;
            } else {
              // Çok uzunsa muhtemelen HTML hata sayfasıdır
              errorMessage =
                  "Sunucu HTML hata sayfası döndürdü. Konsola bakınız.";
            }
          }
        }
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      // Bağlantı hataları (Sunucu kapalı, internet yok vs.)
      debugPrint("BAĞLANTI HATASI: $e");
      throw Exception("Bağlantı hatası: ${e.message}");
    } catch (e) {
      // Diğer hatalar
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }
}
