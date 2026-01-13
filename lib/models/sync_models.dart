// lib/models/sync_models.dart

class ProductSimple {
  final String id; // Guid
  final String barcode;
  final String name;
  final String color;

  ProductSimple(
      {required this.id,
      required this.barcode,
      required this.name,
      required this.color});

  factory ProductSimple.fromJson(Map<String, dynamic> json) {
    return ProductSimple(
      id: json['id'].toString(),
      barcode: json['barcode'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

class SyncData {
  final String sessionId;
  final String sessionTitle;
  final List<ProductSimple> products;

  SyncData(
      {required this.sessionId,
      required this.sessionTitle,
      required this.products});

  factory SyncData.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<ProductSimple> productList =
        list.map((i) => ProductSimple.fromJson(i)).toList();

    return SyncData(
      sessionId: json['sessionId'].toString(),
      sessionTitle: json['sessionTitle'] ?? '',
      products: productList,
    );
  }
}

// Sunucuya göndereceğimiz sayım verisi modeli
class CountEntryRequest {
  final String sessionId;
  final String productId;
  final int quantity;
  final String deviceId;
  final String deviceDate;

  CountEntryRequest({
    required this.sessionId,
    required this.productId,
    required this.quantity,
    required this.deviceId,
    required this.deviceDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'productId': productId,
      'quantity': quantity,
      'deviceId': deviceId,
      'deviceDate': deviceDate,
    };
  }
}
