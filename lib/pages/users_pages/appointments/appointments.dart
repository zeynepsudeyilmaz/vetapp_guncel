import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'package:veteriner_uygulamasi/services/appointment/appointment.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  final appointmentService = Appointment();

  // vet adını al
  Future<String?> getVetName(String vetId) async {
    final vetDoc = await FirebaseFirestore.instance
        .collection("vets")
        .doc(vetId)
        .collection("clinicInfo")
        .doc("info")
        .get();

    if (vetDoc.exists && vetDoc.data() != null) {
      return vetDoc.data()!['companyName'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: appointmentService.getAppointmentInfo(),
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
                  final vetId = appointment['vetId'];
                  DateTime date;

                  if (appointment['date'] is Timestamp) {
                    date = (appointment['date'] as Timestamp).toDate();
                  } else {
                    date = DateTime.parse(appointment['date']);
                  }

                  final hour = appointment['hour'];
                  final appointmentId = appointment.id;

                  return FutureBuilder<String?>(
                    future: getVetName(vetId),
                    builder: (context, vetSnapshot) {
                      if (vetSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final vetName = vetSnapshot.data;

                      return Slidable(
                        key: ValueKey(appointmentId),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Randevu İptal"),
                                      content: const Text(
                                          "Bu randevuyu iptal etmek istediğinize emin misiniz?"),
                                      actions: [
                                        MyButton(
                                          onPressed: () => appointmentService
                                              .deleteAppointment(appointmentId),
                                          text: "Sil",
                                        ),
                                        MyButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          text: "İptal",
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Sil',
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF757EFA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text('Veteriner: $vetName'),
                            subtitle: Text(
                              'Tarih: ${date.toLocal().toString().split(' ')[0]}, Saat: $hour',
                            ),
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
