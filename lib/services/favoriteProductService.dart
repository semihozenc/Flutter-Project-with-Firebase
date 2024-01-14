import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoriteService {
  final favoriteCollection = FirebaseFirestore.instance.collection("favorites");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> createFavorite({required String urun}) async {
    try {
      // Kontrol et: Eğer aynı ürün zaten sepetinizde varsa eklemeyi yapma
      bool isAlreadyInList = await isProductInFavoriteList(urun);

      if (!isAlreadyInList) {
        await favoriteCollection.add({
          "urun": FirebaseFirestore.instance.doc('products/$urun'),
          "user": FirebaseFirestore.instance
              .doc('users/${firebaseAuth.currentUser!.uid}'),
        });
        Fluttertoast.showToast(
          msg: "Ürün Favori Listesine Eklendi",
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Bu ürün Zaten Favori Listenizde",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Favori Listesine Eklenirken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // Yeni eklenen fonksiyon: Belirli bir ürünün sepete eklenip eklenmediğini kontrol eder
  Future<bool> isProductInFavoriteList(String productId) async {
    try {
      QuerySnapshot querySnapshot = await favoriteCollection
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

  Future<void> removeFavoriteItem(String productId) async {
    try {
      await favoriteCollection
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
          msg: "Favori Listesindeki Ürün Kaldırıldı.", toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Favori Listesinden Kaldırılırken Hata Oluştu",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<List<DocumentSnapshot>> getFavoriteListItems() async {
    try {
      QuerySnapshot querySnapshot = await favoriteCollection
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
