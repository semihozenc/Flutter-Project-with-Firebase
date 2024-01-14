import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_uygulama/services/authService.dart';
import 'package:mobil_uygulama/services/productService.dart';
import 'package:mobil_uygulama/urunduzenle.dart';
import 'urundetay.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();
  final firebaseAuth = FirebaseAuth.instance;

  Future<bool> _isAdmin = Future<bool>.value(false);
  late Future<List<Map<String, dynamic>>> urunlerFuture;

  @override
  void initState() {
    super.initState();
    _updateAdminStatus();
    urunlerFuture = _productService.getAllProducts();
  }

  Future<void> _updateAdminStatus() async {
    _isAdmin = _authService.isAdmin();
  }

  Future<void> _updateProductList() async {
    setState(() {
      urunlerFuture = _productService.getAllProducts();
    });
  }

  void _onProductTapped(Map<String, dynamic> product) {
    _isAdmin.then((bool isAdmin) {
      if (isAdmin) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UrunDuzenle(
              productId: product["id"],
              productName: product["ad"],
              productDesc: product["aciklama"],
              productPrice: product["fiyat"],
              productQuantity: product["adet"], // Adet bilgisi
              // Diğer ürün detayları
            ),
          ),
        ).then((_) {
          _updateProductList();
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UrunDetay(product: product),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: urunlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> urunler = snapshot.data ?? [];
            return ListView.builder(
              itemCount: urunler.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(urunler[index]["ad"] ?? ""),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Adet: ${urunler[index]["adet"] ?? "Belirtilmemiş"}'),
                        Text('Fiyat: ${urunler[index]["fiyat"]} TL'),
                      ],
                    ),
                    onTap: () => _onProductTapped(urunler[index]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Anasayfa(),
  ));
}
