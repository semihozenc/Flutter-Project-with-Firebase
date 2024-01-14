import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/productService.dart';

import 'main.dart';

class UrunEkle extends StatefulWidget {
  const UrunEkle({Key? key}) : super(key: key);

  @override
  UrunEkleState createState() => UrunEkleState();
}

class UrunEkleState extends State<UrunEkle> {
  final TextEditingController _urunAdiController = TextEditingController();
  final TextEditingController _urunAciklamaController = TextEditingController();
  final TextEditingController _urunFiyatiController = TextEditingController();
  final TextEditingController _urunAdetiController = TextEditingController();

  final ProductService _productService = ProductService();
  final _formKey = GlobalKey<FormState>(); // Form anahtarı

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _urunAdiController,
                decoration: const InputDecoration(labelText: 'Ürün Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ürün adı boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _urunAciklamaController,
                decoration: const InputDecoration(labelText: 'Ürün Açıklama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ürün Açıklama boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _urunAdetiController,
                decoration: const InputDecoration(labelText: 'Ürün Adeti'),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ürün adeti boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _urunFiyatiController,
                decoration: const InputDecoration(labelText: 'Ürün Fiyatı'),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ürün fiyatı boş olamaz';
                  }
                  // Fiyatı kontrol etmek için özel bir şart ekleyebilirsiniz
                  // Örneğin: Fiyat 0'dan büyük olmalı
                  // if (double.tryParse(value) <= 0) {
                  //   return 'Geçerli bir fiyat girin';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _onCreateProduct(context);
                },
                child: const Text(
                  'Ürünü Oluştur',
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCreateProduct(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final String urunAdi = _urunAdiController.text.trim();
      final String urunAciklama = _urunAciklamaController.text.trim();
      final double urunFiyati = double.tryParse(_urunFiyatiController.text.trim()) ?? 0;
      final int urunAdeti = int.tryParse(_urunAdetiController.text.trim()) ?? 0;

      _productService.createProduct(ad: urunAdi, aciklama: urunAciklama, adet: urunAdeti, fiyat: urunFiyati);

      // Bu sayfayı kapat ve anasayfaya dön
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Urunler()),
      );
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: UrunEkle(),
  ));
}