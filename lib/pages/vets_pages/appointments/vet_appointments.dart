import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/services/appointment/appointment.dart';

class VetAppointments extends StatefulWidget {
  const VetAppointments({super.key});

  @override
  State<VetAppointments> createState() => _VetAppointmentsState();
}

class _VetAppointmentsState extends State<VetAppointments> {
  final appointmentService = Appointment();
  final String vetId = FirebaseAuth.instance.currentUser!.uid;
  // kullanıcı bilgisini al
  Future<String?> getUserName(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    if (userDoc.exists && userDoc.data() != null) {
      return '${userDoc.data()!['name']} ${userDoc.data()!['surname']}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: appointmentService.getVetAppointments(vetId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Bir hata oluştu."));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final appointmentList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: appointmentList.length,
                itemBuilder: (context, index) {
                  final appointment = appointmentList[index];
                  final userId = appointment['userId'];
                  DateTime date;

                  if (appointment['date'] is Timestamp) {
                    date = (appointment['date'] as Timestamp).toDate();
                  } else {
                    date = DateTime.parse(appointment['date']);
                  }

                  final hour = appointment['hour'];

                  return FutureBuilder<String?>(
                    future: getUserName(userId),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final userName = userSnapshot.data;

                      return Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF757EFA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text('Kullanıcı: $userName'),
                          subtitle: Text(
                            'Tarih: ${date.toLocal().toString().split(' ')[0]}, Saat: $hour',
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text("Randevu bulunamadı."));
            }
          },
        ),
      ),
    );
  }
}
