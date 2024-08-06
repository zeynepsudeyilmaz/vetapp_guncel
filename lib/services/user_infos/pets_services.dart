import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PetFirebaseServices {
  final petReference = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("pets");

  //hayvan ekleme
  Future<void> addPet({
    required String petName,
    required String petType,
    required int petAge,
    required String petUrl,
  }) async {
    await petReference.add({
      "petName": petName,
      "petType": petType,
      "petAge": petAge,
      "petUrl": petUrl
    });
  }

  //hayvanları listeleme
  Stream<QuerySnapshot> listPets() {
    return petReference.snapshots();
  }

  //hayvan bilgisi güncelleme
  Future<void> updatePetList(String petId, Map<String, dynamic> newData) {
    return petReference.doc(petId).update(newData);
  }

  //hayvan silme
  Future<void> deletePet(String petId) async {
    await petReference.doc(petId).delete();
  }

  // Fotoğrafı Firebase Storage'a yükleme
  Future<String> uploadPetImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      String fileName = 'pets/${DateTime.now().millisecondsSinceEpoch}.png';
      UploadTask uploadTask = storageRef.child(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Fotoğrafın URL'sini döndür
    } catch (e) {
      throw Exception("Fotoğraf yükleme başarısız: $e");
    }
  }

  // hayvan bilgilerini ama
  Future<DocumentSnapshot> getPetInfo(String petId) async {
    try {
      DocumentSnapshot petInfo = await petReference.doc(petId).get();

      if (petInfo.exists) {
        return petInfo;
      } else {
        throw Exception("Hayvan bulunamadı.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
