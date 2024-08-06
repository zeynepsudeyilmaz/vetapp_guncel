import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductFirebaseServices {
  final productReference = FirebaseFirestore.instance
      .collection("vets")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("clinicInfo")
      .doc("info")
      .collection("products");

  //Ürün Ekleme
  Future<void> addProducts({
    required String productName,
    required double productPrice,
    required int productCount,
    required String productUrl,
  }) async {
    await productReference.add({
      "productName": productName,
      "productPrice": productPrice,
      "productCount": productCount,
      "productUrl": productUrl,
    });
  }

  //Ürün Listeleme
  Stream<QuerySnapshot> listProducts() {
    return productReference.snapshots();
  }

  //Ürün Güncelleme
  Future<void> updateProductList(
      String productId, Map<String, dynamic> newData) {
    return productReference.doc(productId).update(newData);
  }

  //Ürün Silme
  Future<void> deleteProduct(String productId) async {
    await productReference.doc(productId).delete();
  }

  // Ürün Bilgilerini Alma
  Future<DocumentSnapshot> getProductInfo(String productId) async {
    try {
      DocumentSnapshot productInfo =
          await productReference.doc(productId).get();

      if (productInfo.exists) {
        return productInfo;
      } else {
        throw Exception("Ürün bulunamadı.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
