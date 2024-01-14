import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class CartService {
  final cartCollection = FirebaseFirestore.instance.collection("carts");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> createCart(BuildContext context, {required String urun, int adet = 1}) async {
    try {
      // Kontrol et: Eğer aynı ürün zaten sepetinizde varsa eklemeyi yapma
      bool isAlreadyInCart = await isProductInCart(urun);

      if (!isAlreadyInCart) {
        await cartCollection.add({
          "urun": FirebaseFirestore.instance.doc('products/$urun'),
          "user": FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'),
          "adet": adet, // Ürün adedini ekleyin
        });
        Fluttertoast.showToast(
          msg: "Ürün Sepete Eklendi",
          toastLength: Toast.LENGTH_LONG,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Urunler(index: 1)),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Bu ürün zaten sepetinizde",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Sepete Eklenirken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<bool> isProductInCart(String productId) async {
    try {
      QuerySnapshot querySnapshot = await cartCollection
          .where("user",
          isEqualTo: FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'))
          .where("urun",
          isEqualTo: FirebaseFirestore.instance.doc('products/$productId'))
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      return false;
    }
  }

  Future<void> removeCartItem(String productId) async {
    try {
      await cartCollection
          .where("user",
          isEqualTo: FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'))
          .where("urun",
          isEqualTo: FirebaseFirestore.instance.doc('products/$productId'))
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      Fluttertoast.showToast(
          msg: "Sepetteki Ürün Kaldırıldı.", toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Sepetten Kaldırılırken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<List<DocumentSnapshot>> getCartItems() async {
    try {
      QuerySnapshot querySnapshot = await cartCollection
          .where("user",
          isEqualTo: FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'))
          .get();
      return querySnapshot.docs;
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      return [];
    }
  }

  Future<void> purchaseCartItems(BuildContext context) async {
    try {
      // Kullanıcının sepetini getir
      QuerySnapshot cartSnapshot = await cartCollection
          .where("user",
          isEqualTo: FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'))
          .get();

      // Her bir ürünü sepetten sil ve products tablosundaki sayıyı güncelle
      for (var cartItem in cartSnapshot.docs) {
        var urunRef = cartItem["urun"] as DocumentReference;
        var adet = cartItem["adet"] ?? 1;

        // Sepetten ürünü sil
        await cartItem.reference.delete();

        // Ürün sayısını products tablosunda güncelle
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot urunSnapshot = await transaction.get(urunRef);
          var urunData = urunSnapshot.data() as Map<String, dynamic>;

          // Eğer ürün sayısı, satın alınan adetten küçükse, ürünü tamamen sil
          if (urunData["adet"] <= adet) {
            await transaction.delete(urunRef);
          } else {
            await transaction.update(urunRef, {"adet": urunData["adet"] - adet});
          }
        });
      }

      // TODO: Satın alındı işlemi veya başka bir işlem gerçekleştirilebilir.
      // Örneğin: Sipariş oluşturma, ödeme işlemi, envanter güncelleme vb.

      // Başarılı bir şekilde satın alındı mesajını göster
      Fluttertoast.showToast(
        msg: "Satın Alma Başarılı",
        toastLength: Toast.LENGTH_LONG,
      );

      // Ürünler sayfasına geri dön
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Urunler(index: 1)),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Satın Alma İşlemi Başarısız",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
