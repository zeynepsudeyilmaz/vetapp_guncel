import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Appointment {
  final appointmentReference = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("appointment");

  final vetAppointmentReference = FirebaseFirestore.instance
      .collection("vets")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("appointments");

  //randevu ekleme
  Future<void> addAppointment({
    required String vetId,
    required DateTime date,
    required String hour,
  }) async {
    await appointmentReference.add({
      'vetId': vetId,
      'date': date.toIso8601String(), //ISO formatı
      'hour': hour,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(), //oluşturma tarihi
    });
    // vet veritabanına ekle
    await vetAppointmentReference.add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'date': date.toIso8601String(),
      'hour': hour,
      'createdAt': FieldValue.serverTimestamp(), // Oluşturma tarihi
    });
  }

  //randevu bilgilerini alma
  Stream<QuerySnapshot> getAppointmentInfo() {
    return appointmentReference
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Veterinerin randevularını alma
  Stream<QuerySnapshot> getVetAppointments(String vetId) {
    return vetAppointmentReference
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //randevu silme
  Future<void> deleteAppointment(String appointmentId) async {
    await appointmentReference.doc(appointmentId).delete();
  }

  Stream<QuerySnapshot> getUpComingAppointmen(String vetId) {
    return vetAppointmentReference
        .where('date', isGreaterThan: DateTime.now().toIso8601String())
        .orderBy('date')
        .snapshots();
  }
}
