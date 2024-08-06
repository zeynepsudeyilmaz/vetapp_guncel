/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/vet infos/vets_section.dart';

class Vets extends StatefulWidget {
  const Vets({super.key});

  @override
  State<Vets> createState() => _VetsState();
}

class _VetsState extends State<Vets> {
  final VetFirebaseServices vetFirebaseService = VetFirebaseServices();
  DocumentSnapshot? clinicInfo;

  @override
  void initState() {
    super.initState();
    fetchClinicInfo(); // Veriyi çekme fonksiyonu
  }

  Future<void> fetchClinicInfo() async {
    try {
      clinicInfo = await vetFirebaseService.getClinicInfo(); // Belgeyi al
      setState(() {}); // State'i güncelle
    } catch (e) {
      print("Hata: $e"); // Hata durumunu konsola yazdır
    }
  }

  @override
  Widget build(BuildContext context) {
    if (clinicInfo == null) {
      return const Center(
          child:
              CircularProgressIndicator()); // Veri yükleniyorsa loading circle
    }

    if (clinicInfo!.exists) {
      final companyName = clinicInfo!['companyName'];
      final companyAddress = clinicInfo!['companyAddress'];
      final email = clinicInfo!['email'];
      final phone = clinicInfo!['phone'];
      final hours = clinicInfo!['hours'];
      final imageUrl = clinicInfo!['imageUrl']; // Resim URL'si eklendi

      return Container(
        height: 300,
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F8FF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl.isNotEmpty
                    ? imageUrl
                    : "https://example.com/default.png", // Varsayılan resim
                height: 150,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                companyName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                companyAddress,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Email: $email',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Phone: $phone',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Hours: $hours',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Center(
          child: Text("Veteriner bulunamadı.")); // Eğer belge yoksa
    }
  }
}
 */