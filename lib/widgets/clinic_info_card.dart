import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'package:veteriner_uygulamasi/pages/vets_pages/clinic_infos/clinic_infos.dart';

class ClinicInfoCard extends StatefulWidget {
  const ClinicInfoCard({super.key});

  @override
  State<ClinicInfoCard> createState() => _ClinicInfoCardState();
}

class _ClinicInfoCardState extends State<ClinicInfoCard> {
  String clinicName = "";
  String clinicAddress = "";
  String clinicPhone = "";
  String clinicEmail = "";
  String clinicHours = "";
  bool isInfoEmpty = true;

  @override
  void initState() {
    super.initState();
    getClinicInfo();
  }

  // Klinik bilgilerini alma
  Future<void> getClinicInfo() async {
    DocumentSnapshot clinicInfo = await FirebaseFirestore.instance
        .collection("vets")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("clinicInfo")
        .doc("info")
        .get();

    // Verilerin varlığını kontrol et
    if (clinicInfo.exists && clinicInfo.data() != null) {
      final data = clinicInfo.data() as Map<String, dynamic>;

      // Klinik bilgileri varsa
      setState(() {
        clinicName = data['companyName'] ?? "Klinik Adı Belirtilmemiş";
        clinicAddress = data['companyAddress'] ?? "Adres Belirtilmemiş";
        clinicPhone = data['phone'] ?? "Telefon Belirtilmemiş";
        clinicEmail = data['email'] ?? "E-posta Belirtilmemiş";
        clinicHours = data['hours'] ?? "Saat Belirtilmemiş";
        isInfoEmpty = false;
      });
    } else {
      // Bilgi yoksa
      setState(() {
        isInfoEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.32,
      child: Card(
        color: const Color(0xFFF2F3FA),
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: isInfoEmpty
                ? const Center(
                    child: Text(
                      "Henüz klinik bilgilerinizi eklemediniz. Lütfen ekleyin.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              clinicName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          MyButton(
                            text: "Düzenle",
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ClinicInfos(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Adres: $clinicAddress",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Telefon: $clinicPhone",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "E-posta: $clinicEmail",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Çalışma Saatleri: $clinicHours",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
