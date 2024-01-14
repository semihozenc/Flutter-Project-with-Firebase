import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductService {
  final productCollection = FirebaseFirestore.instance.collection("products");

  Future<void> createProduct({
    required String ad,
    required String aciklama,
    required double fiyat,
    required int adet, // Varsayılan adet değeri 0
  }) async {
    try {
      await productCollection.add({
        "ad": ad,
        "aciklama": aciklama,
        "fiyat": fiyat,
        "adet": adet,
      });
      Fluttertoast.showToast(
        msg: "Ürün Eklendi",
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Eklenirken Hata Oluştu",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await productCollection.get();

      List<Map<String, dynamic>> products = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return {
          "id": doc.id,
          "ad": doc["ad"],
          "aciklama": doc["aciklama"],
          "fiyat": doc["fiyat"],
          "adet": doc["adet"], // Adet değeri belirtilmemişse, varsayılan olarak 0
        };
      }).toList();

      return products;
    } catch (e) {
      if (kDebugMode) {
        print("Ürünler getirilirken hata oluştu: $e");
      }
      return [];
    }
  }

  Future<void> updateProduct({
    required String productId,
    required String newName,
    required String newDesc,
    required double newPrice,
    required int newAdet,
  }) async {
    try {
      Map<String, dynamic> updatedData = {
        "ad": newName,
        "aciklama": newDesc,
        "fiyat": newPrice,
        "adet": newAdet
      };

      await productCollection.doc(productId).update(updatedData);
      Fluttertoast.showToast(
        msg: "Ürün Güncellendi",
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Güncellenirken Hata Oluştu",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await productCollection.doc(productId).delete();
      Fluttertoast.showToast(
        msg: "Ürün Silindi",
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ürün Silinirken Hata Oluştu",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
}