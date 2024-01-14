import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobil_uygulama/services/cartService.dart';
import 'package:mobil_uygulama/services/wishlistService.dart';
import 'package:mobil_uygulama/services/favoriteProductService.dart';

class UrunDetay extends StatefulWidget {
  final Map<String, dynamic> product;

  UrunDetay({Key? key, required this.product}) : super(key: key);

  @override
  _UrunDetayState createState() => _UrunDetayState();
}

class _UrunDetayState extends State<UrunDetay> {
  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();
  final FavoriteService _favoriteService = FavoriteService();
  int _selectedAdet = 1; // Varsayılan olarak 1 adet seçili

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product["ad"] ?? ""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Ürün Açıklaması: ${widget.product["aciklama"] ?? ""}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Ürün Fiyatı: ${widget.product["fiyat"]} TL',
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Diğer ürün detayları
            const SizedBox(height: 16.0), // Boşluk ekleyebilirsiniz
            ElevatedButton(
              onPressed: () {
                _showAdetDialog(context);
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: Text(
                'Sepete Ekle',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 8.0), // Boşluk ekleyebilirsiniz
            ElevatedButton(
              onPressed: () {
                // Favori listesine ekleme işlemleri buraya gelecek
                _favoriteService.createFavorite(
                  urun: '${widget.product["id"]}',
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text(
                'Favori Listesine Ekle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 8.0), // Boşluk ekleyebilirsiniz
            ElevatedButton(
              onPressed: () {
                // İstek listesine ekleme işlemleri buraya gelecek
                _wishlistService.createWish(
                  urun: '${widget.product["id"]}',
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                textStyle: const TextStyle(fontSize: 18.0),
              ),
              child: const Text(
                'İstek Listesine Ekle',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Kaç Adet?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Üründen kaç adet istediğinizi seçiniz:"),
                  const SizedBox(height: 10),
                  DropdownButton<int>(
                    value: _selectedAdet,
                    items: List.generate(30, (index) => index + 1)
                        .map((adet) => DropdownMenuItem<int>(
                      value: adet,
                      child: Text(adet.toString()),
                    ))
                        .toList(),
                    onChanged: (int? value) {
                      setState(() {
                        _selectedAdet = value ?? 1;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("İptal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _addToCart(_selectedAdet);
                  },
                  child: Text("Sepete Ekle ($_selectedAdet Adet)"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addToCart(int adet) async {
    // İlgili ürünün Firestore'dan stok bilgisini al
    var urunSnapshot = await FirebaseFirestore.instance
        .collection('products')
        .doc('${widget.product["id"]}')
        .get();

    // Firestore'dan alınan stok bilgisini kontrol et
    int stokAdeti = urunSnapshot["adet"] ?? 0;
    if (adet > stokAdeti) {
      // Eğer seçilen adet stoktan fazlaysa, kullanıcıya uyarı ver
      Fluttertoast.showToast(
        msg: "Ürün Adeti Geçersiz",
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      // Eğer stok yeterliyse, sepete ekleme işlemleri yap
      _cartService.createCart(
        context,
        urun: '${widget.product["id"]}',
        adet: adet,
      );
      // İsteğe bağlı olarak stoktan düşme işlemi yapılabilir
      // Bu adımda Firebase Firestore'da güncelleme yapılması gerekir
    }
  }
}
