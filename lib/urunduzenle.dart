import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/notificationService.dart';
import 'package:mobil_uygulama/services/productService.dart';

class UrunDuzenle extends StatefulWidget {
  final String productId;
  final String productName;
  final String productDesc;
  final double productPrice;
  final int productQuantity;

  const UrunDuzenle({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productDesc,
    required this.productPrice,
    required this.productQuantity
  }) : super(key: key);

  @override
  UrunDuzenleState createState() => UrunDuzenleState();
}

class UrunDuzenleState extends State<UrunDuzenle> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final ProductService _productService = ProductService();

  final _formKey = GlobalKey<FormState>(); // Form anahtarı

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.productName;
    _descController.text = widget.productDesc;
    _priceController.text = widget.productPrice.toString();
    _quantityController.text = widget.productQuantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ürün Adı'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Ürün Adı',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ürün adı boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Ürün Açıklaması'),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  hintText: 'Ürün Açıklaması',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ürün Açıklaması boş olamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Ürün Adeti'),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ürün Adeti',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ürün adeti boş olamaz';
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
              const Text('Ürün Fiyatı'),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ürün Fiyatı',
                ),
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
              // Sil ve Güncelle butonları
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Validasyon kontrolü
                      if (_formKey.currentState?.validate() ?? false) {
                        // Ürünü güncelleme işlemleri
                        String newName = _nameController.text;
                        String newDesc = _descController.text;
                        int newAdet = int.tryParse(_quantityController.text) ?? 0;
                        double newPrice = double.tryParse(_priceController.text) ?? 0.0;

                        await _productService.updateProduct(
                          productId: widget.productId,
                          newName: newName,
                          newDesc: newDesc,
                          newAdet: newAdet,
                          newPrice: newPrice,
                        );

                        print(widget.productPrice);
                        if (newPrice > widget.productPrice) {
                          NotificationService().showNotification(title: "Fiyat Güncellemesi!", body: "${widget.productName} Ürününün Fiyatı Yükseldi...");
                        } else if (newPrice < widget.productPrice) {
                          NotificationService().showNotification(title: "Fiyat Güncellemesi!", body: "${widget.productName} Ürününün Fiyatı Düştü...");
                        } else {}

                        // Geri git
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Güncelle',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0), // Düğmeler arasında boşluk bırakmak için SizedBox ekledik.
                  ElevatedButton(
                    onPressed: () async {
                      await _productService.deleteProduct(widget.productId);
                      // Geri git
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Kırmızı renk
                    ),
                    child: const Text(
                      'Sil',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
