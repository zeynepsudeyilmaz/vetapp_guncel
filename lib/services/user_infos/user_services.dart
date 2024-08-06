import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirebaseServices {
  final userInfo = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  //kullanıcı bilgilerini alma
  Future<DocumentSnapshot> getUserInfo() async {
    try {
      return await userInfo.get();
    } catch (e) {
      rethrow;
    }
  }

  // kullanıcı bilgilerini güncelle
  Future<void> updateUserInfo({
    required String name,
    required String surname,
    required String email,
    String? phone,
  }) async {
    try {
      await userInfo.set({
        'name': name,
        'surname': surname,
        'email': email,
        'phone': phone,
      });
    } catch (e) {
      rethrow;
    }
  }
}
