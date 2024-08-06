import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'package:veteriner_uygulamasi/widgets/list_notes.dart';
import 'package:veteriner_uygulamasi/widgets/notes.dart';

import '../../../widgets/clinic_info_card.dart';
import '../../users_pages/log/login_or_register.dart';
import '../../../services/appointment/appointment.dart';

class VetHomePage extends StatefulWidget {
  const VetHomePage({super.key});

  @override
  State<VetHomePage> createState() => _VetHomePageState();
}

class _VetHomePageState extends State<VetHomePage> {
  String username = "";
  final appointmentService = Appointment();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection("vets")
          .doc(user.uid)
          .collection("clinicInfo")
          .doc("info")
          .get();
      // Belgenin olup olmadığını kontrol etme
      if (userInfo.exists) {
        setState(() {
          username = "${userInfo["companyName"]}";
        });
      }
    }
  }

  // Çıkış yapma
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FA),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selam, $username!",
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        IconButton(
                          onPressed: () {
                            logout();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginorRegister()));
                          },
                          icon: const Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                child: ClinicInfoCard(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FA),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hızlı Notlar",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            MyButton(
                              text: "Tümünü Gör",
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ListNotes()));
                              },
                              fontSize: 14,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Notes(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
