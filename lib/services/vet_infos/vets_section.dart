import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VetsSection extends StatefulWidget {
  const VetsSection({super.key});

  @override
  State<VetsSection> createState() => _VetsSectionState();
}

class _VetsSectionState extends State<VetsSection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vets').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Bir hata oluştu."));
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final vetList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vetList.length,
            itemBuilder: (context, index) {
              final vetId = vetList[index].id;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('vets')
                    .doc(vetId)
                    .collection('clinicInfo')
                    .doc('info')
                    .get(),
                builder: (context, clinicSnapshot) {
                  if (clinicSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (clinicSnapshot.hasError) {
                    return ListTile(
                      title: Text('Hata: ${clinicSnapshot.error}'),
                    );
                  }

                  if (!clinicSnapshot.hasData || !clinicSnapshot.data!.exists) {
                    return const ListTile(
                      title: Text('Veteriner bilgisi bulunamadı.'),
                    );
                  }

                  final clinicData =
                      clinicSnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    title: Text(clinicData['companyName']),
                    subtitle: Text(clinicData['companyAddress']),
                    trailing: Text(clinicData['phone']),
                    onTap: () {},
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text("Veteriner bilgisi bulunamadı"),
          );
        }
      },
    );
  }
}