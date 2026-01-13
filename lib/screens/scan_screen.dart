import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_master_mobile/models/sync_models.dart'; // Modelleri ekledik

class ScanScreen extends StatefulWidget {
  // Ekrana veri gönderilmesini zorunlu kıldık
  final SyncData syncData;
  final String token; // Kayıt atarken lazım olabilir

  const ScanScreen({super.key, required this.syncData, required this.token});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isScanning = true;

  // Geçici olarak sayımları tutacağımız liste
  List<CountEntryRequest> _unsavedCounts = [];

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          _isScanning = false;
        });
        _processBarcode(code);
      }
    }
  }

  // Barkodu yerel listede arama fonksiyonu
  void _processBarcode(String barcode) {
    // 1. Ürünü bul
    ProductSimple? foundProduct;
    try {
      foundProduct =
          widget.syncData.products.firstWhere((p) => p.barcode == barcode);
    } catch (e) {
      foundProduct = null;
    }

    if (foundProduct != null) {
      _showQuantityDialog(foundProduct);
    } else {
      // Ürün yoksa hata göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Tanımsız Barkod: $barcode"),
            backgroundColor: Colors.red),
      );
      // Biraz bekle sonra devam et
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isScanning = true);
      });
    }
  }

  Future<void> _showQuantityDialog(ProductSimple product) async {
    final TextEditingController qtyController =
        TextEditingController(text: "1");

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Ürün Bulundu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ürün: ${product.name}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              Text("Renk: ${product.color}"),
              const SizedBox(height: 10),
              Text("Barkod: ${product.barcode}"),
              const SizedBox(height: 20),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Adet Giriniz",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isScanning = true);
              },
              child: const Text("İptal", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                final int amount = int.tryParse(qtyController.text) ?? 0;
                if (amount > 0) {
                  // LİSTEYE EKLE
                  final entry = CountEntryRequest(
                    sessionId: widget.syncData.sessionId,
                    productId: product.id,
                    quantity: amount,
                    deviceId: "Android_Cihaz", // İlerde gerçek ID alınabilir
                    deviceDate: DateTime.now().toIso8601String(),
                  );

                  setState(() {
                    _unsavedCounts.add(entry);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "${product.name} ($amount) eklendi. Toplam kuyruk: ${_unsavedCounts.length}")),
                  );

                  Navigator.pop(context);
                  setState(() => _isScanning = true);
                }
              },
              child: const Text("Listeye Ekle"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sayım (${widget.syncData.sessionTitle})"),
        actions: [
          // Kuyruktaki veri sayısını gösteren bir badge
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("${_unsavedCounts.length} Kayıt",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _cameraController,
              onDetect: _onDetect,
            ),
          ),
          // Senkronize Et Butonu (İlerde işlevselleşecek)
          if (_unsavedCounts.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.yellow[100],
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: Text("Sunucuya Gönder (${_unsavedCounts.length})"),
                onPressed: () {
                  // BURADA SyncService.pushCounts ÇAĞRILACAK
                  // Şimdilik sadece print ediyoruz
                  print("GÖNDERİLİYOR...");
                },
              ),
            )
        ],
      ),
    );
  }
}
