import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WishlistService {
  final wishlistCollection = FirebaseFirestore.instance.collection("wishlists");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> createWish({required String urun}) async {
    try {
      // Kontrol et: Eğer aynı ürün zaten sepetinizde varsa eklemeyi yapma
      bool isAlreadyInCart = await isProductInWishList(urun);

      if (!isAlreadyInCart) {
        await wishlistCollection.add({
          "urun": FirebaseFirestore.instance.doc('products/$urun'),
          "user": FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'),
        });
        Fluttertoast.showToast(
          msg: "Ürün İstek Listesine Eklendi",
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Bu ürün Zaten İstek Listenizde",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün İstek Listesine Eklenirken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Yeni eklenen fonksiyon: Belirli bir ürünün sepete eklenip eklenmediğini kontrol eder
  Future<bool> isProductInWishList(String productId) async {
    try {
      QuerySnapshot querySnapshot = await wishlistCollection
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

  Future<void> removeWishItem(String productId) async {
    try {
      await wishlistCollection
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
          msg: "İstek Listesindeki Ürün Kaldırıldı.", toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün İstek Listesinden Kaldırılırken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<List<DocumentSnapshot>> getWishListItems() async {
    try {
      QuerySnapshot querySnapshot = await wishlistCollection
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
}
