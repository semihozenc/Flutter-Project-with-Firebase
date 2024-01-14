import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/cartService.dart';

class Sepet extends StatefulWidget {
  const Sepet({Key? key}) : super(key: key);

  @override
  _SepetState createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  final CartService _cartService = CartService();
  late Future<List<DocumentSnapshot>> cartItemsFuture;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = _cartService.getCartItems();
  }

  Future<void> _removeFromCart(String productId) async {
    await _cartService.removeCartItem(productId);
    // Notify that the cart has been updated
    setState(() {
      // Update the list with the freshly fetched data
      cartItemsFuture = _cartService.getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            List<DocumentSnapshot> cartItems = snapshot.data ?? [];
            double toplamFiyat = 0;

            if (cartItems.isEmpty) {
              return Center(
                child: Text('Sepetinizde henüz ürün bulunmamaktadır.'),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: cartItems[index]["urun"].get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading...");
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            var urunData = snapshot.data!.data() as Map<String, dynamic>;

                            // Continue with your widget creation using urunData
                            return Card(
                              child: ListTile(
                                title: Text('Ürün Adı: ${urunData["ad"] ?? ""}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Fiyat: ${urunData["fiyat"]} TL'),
                                    const SizedBox(height: 4.0),
                                    Text('Adet: ${cartItems[index]["adet"] ?? 1}'),
                                    const SizedBox(height: 4.0),
                                    FutureBuilder<DocumentSnapshot>(
                                      future: cartItems[index]["urun"].get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Text("Loading...");
                                        } else if (snapshot.hasError) {
                                          return Text("Error: ${snapshot.error}");
                                        } else {
                                          var urunData = snapshot.data!.data() as Map<String, dynamic>;
                                          int adet = cartItems[index]["adet"] ?? 1;
                                          double fiyat = urunData["fiyat"] ?? 0;
                                          toplamFiyat = adet * fiyat;
                                          return Text('Toplam Fiyat: $toplamFiyat TL');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Perform removal operations here
                                    if (kDebugMode) {
                                      print("Sepetten Kaldır Butona tıklandı: ${cartItems[index]["urun"].id}");
                                    }
                                    _removeFromCart(cartItems[index]["urun"].id);
                                  },
                                  child: const Text(
                                    'Kaldır',
                                    style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Satın al butonuna basıldığında yapılacak işlemler
                        // Örneğin, satın alınan ürünleri işleme alabilir veya başka bir sayfaya yönlendirebilirsiniz
                        _cartService.purchaseCartItems(context);
                      },
                      child: const Text(
                        'Satın Al',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Sepet(),
  ));
}
