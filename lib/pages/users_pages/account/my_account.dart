import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../helper/helper_functions.dart';
import '../../../services/user_infos/user_services.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final UserFirebaseServices firebaseService = UserFirebaseServices();
  bool isEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      DocumentSnapshot userInfo = await firebaseService.getUserInfo();
      nameController.text = userInfo.get("name");
      surnameController.text = userInfo.get("surname");
      emailController.text = userInfo.get("email");
      phoneController.text = userInfo.get("phone") ?? '';
      setState(() {});
    } catch (e) {
      displayMessageToUser('Henüz bilgilerinizi eklemediniz.', context);
    }
  }

  Future<void> saveUserInfo() async {
    try {
      await firebaseService.updateUserInfo(
        name: nameController.text,
        surname: surnameController.text,
        email: emailController.text,
        phone: phoneController.text,
      );
      displayMessageToUser('Bilgiler başarıyla güncellendi.', context);
    } catch (e) {
      displayMessageToUser('Bir hata oluştu: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ad:',
                          style: GoogleFonts.inter(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        isEditing
                            ? TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: "Ad",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              )
                            : Text(
                                nameController.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Soyad:',
                          style: GoogleFonts.inter(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        isEditing
                            ? TextField(
                                controller: surnameController,
                                decoration: const InputDecoration(
                                  hintText: "Soyad",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              )
                            : Text(
                                surnameController.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'E-posta:',
                          style: GoogleFonts.inter(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        isEditing
                            ? TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: "E-posta",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              )
                            : Text(
                                emailController.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Telefon:',
                          style: GoogleFonts.inter(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        isEditing
                            ? TextField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  hintText: "Telefon",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              )
                            : Text(
                                phoneController.text.isEmpty
                                    ? 'Telefon numaranızı ekleyin'
                                    : phoneController.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isEditing) {
              saveUserInfo();
            }
            isEditing = !isEditing;
          });
        },
        child: Icon(isEditing ? Icons.save : Icons.edit),
      ),
    );
  }
}
