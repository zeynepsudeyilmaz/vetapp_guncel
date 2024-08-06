import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/vets/take_appointment.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/vets/vets_products.dart';

class VetDetailsPage extends StatelessWidget {
  final String vetId;

  const VetDetailsPage({
    super.key,
    required this.vetId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detaylar"),
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      backgroundColor: const Color(0xFFE3E5FA),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vets')
            .doc(vetId)
            .collection("clinicInfo")
            .doc("info")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu."));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Veteriner bilgisi bulunamadı."));
          }

          final vetData = snapshot.data!.data() as Map<String, dynamic>;
          final companyName = vetData['companyName'];
          final imageUrl = vetData['imageUrl'];
          final phone = vetData['phone'];
          final email = vetData['email'];
          final companyAddress = vetData['companyAddress'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    companyName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Telefon: $phone"),
                      Text("E-posta: $email"),
                      Text("Adres: $companyAddress"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: "Ürünler"),
                          Tab(text: "Randevu Al"),
                        ],
                      ),
                      SizedBox(
                        height: 800,
                        child: TabBarView(
                          children: [
                            VetsProducts(vetId: vetId),
                            TakeAppointment(
                              vetId: vetId,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
