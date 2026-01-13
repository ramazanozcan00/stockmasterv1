// lib/services/sync_service.dart

import 'package:dio/dio.dart';
import 'package:stock_master_mobile/core/constants.dart';
import 'package:stock_master_mobile/models/sync_models.dart';

class SyncService {
  final Dio _dio = Dio();

  // 1. Verileri İndir (GET)
  Future<SyncData?> downloadData(String token) async {
    final String url = '${Constants.baseUrl}/MobileSync/GetData';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Token'ı header'a ekliyoruz
            "Content-Type": "application/json"
          },
        ),
      );

      if (response.statusCode == 200) {
        return SyncData.fromJson(response.data);
      } else {
        throw Exception("Veri indirilemedi: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Sync Hatası: $e");
    }
  }

  // 2. Verileri Gönder (POST)
  Future<bool> pushCounts(String token, List<CountEntryRequest> counts) async {
    final String url = '${Constants.baseUrl}/MobileSync/PushCounts';

    try {
      final response = await _dio.post(
        url,
        data: counts.map((e) => e.toJson()).toList(), // Listeyi JSON'a çevir
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
