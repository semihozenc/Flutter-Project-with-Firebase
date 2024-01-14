import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobil_uygulama/services/wishlistService.dart';

class IstekListesi extends StatefulWidget {
  const IstekListesi({Key? key}) : super(key: key);

  @override
  _IstekListesiState createState() => _IstekListesiState();
}

class _IstekListesiState extends State<IstekListesi> {
  final WishlistService _wishlistService = WishlistService();
  late Future<List<DocumentSnapshot>> cartItemsFuture;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = _wishlistService.getWishListItems();
  }

  Future<void> _removeFromCart(String productId) async {
    await _wishlistService.removeWishItem(productId);
    // Notify that the cart has been updated
    setState(() {
      // Update the list with the freshly fetched data
      cartItemsFuture = _wishlistService.getWishListItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstek Listem'),
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
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: FutureBuilder<DocumentSnapshot>(
                      future: cartItems[index]["urun"].get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading...");
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          var urunData = snapshot.data!.data() as Map<String, dynamic>;
                          return Text('Ürün Adı: ${urunData["ad"] ?? ""}');
                        }
                      },
                    ),
                    subtitle: FutureBuilder<DocumentSnapshot>(
                      future: cartItems[index]["urun"].get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading...");
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          var urunData = snapshot.data!.data() as Map<String, dynamic>;
                          return Text('Fiyat: ${urunData["fiyat"]} TL');
                        }
                      },
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Perform removal operations here
                        if (kDebugMode) {
                          print("İstek Listesinden Kaldır Butona tıklandı: ${cartItems[index]["urun"].id}");
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
    home: IstekListesi(),
  ));
}
