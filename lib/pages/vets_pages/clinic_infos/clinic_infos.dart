import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/helper/helper_functions.dart';
import '../../../widgets/image_picker.dart';

class ClinicInfos extends StatefulWidget {
  const ClinicInfos({super.key});

  @override
  State<ClinicInfos> createState() => _ClinicInfosState();
}

class _ClinicInfosState extends State<ClinicInfos> {
  bool isEditing = false;
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

  File? _selectedImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    getClinicInfo();
  }

  Future<void> getClinicInfo() async {
    // firestore'dan klinik bilgilerini al
    try {
      DocumentSnapshot clinicInfos = await FirebaseFirestore.instance
          .collection("vets")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("clinicInfo")
          .doc("info")
          .get();
      if (clinicInfos.exists) {
        clinicNameController.text = clinicInfos['companyName'];
        addressController.text = clinicInfos['companyAddress'];
        phoneController.text = clinicInfos['phone'];
        emailController.text = clinicInfos['email'];
        hoursController.text = clinicInfos['hours'];

        imageUrl = clinicInfos['imageUrl'];

        setState(() {});
      } else {
        displayMessageToUser(
            'Henüz klinik bilgilerinizi eklemediniz.', context);
      }
    } catch (e) {
      displayMessageToUser('Bir hata oluştu: $e', context);
    }
  }

  Future<void> saveClinicInfo() async {
    //mevcut olan resim urlsi
    String? currentImageUrl = imageUrl;

    //yeni resim kontrolü
    if (_selectedImage == null) {
      // yeni seçilmemişse mevcut url
      if (currentImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir resim seçin')),
        );
        return;
      }
    } else {
      //yeni resim varsa storage'a onu yükle
      try {
        String fileName = path.basename(_selectedImage!.path);
        Reference storageRef =
            FirebaseStorage.instance.ref().child('pets/$fileName');
        UploadTask uploadTask = storageRef.putFile(_selectedImage!);

        TaskSnapshot taskSnapshot = await uploadTask;
        currentImageUrl = await taskSnapshot.ref.getDownloadURL();
      } catch (e) {
        displayMessageToUser('Resim yüklenirken bir hata oluştu: $e', context);
        return;
      }
    }

    // klinik bilgilerini Firestore'a kaydedin
    try {
      await FirebaseFirestore.instance
          .collection("vets")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("clinicInfo")
          .doc("info")
          .set({
        'companyAddress': addressController.text,
        'companyName': clinicNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'hours': hoursController.text,
        'imageUrl': currentImageUrl,
      });

      displayMessageToUser('Bilgiler başarıyla kaydedildi', context);
    } catch (e) {
      displayMessageToUser('Bir hata oluştu: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.image),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Klinik Fotoğrafı:',
                            style: GoogleFonts.inter(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          // veri varsa yükle
                          if (!isEditing && imageUrl != null)
                            Image.network(
                              imageUrl!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          // veri yoksa
                          else if (!isEditing && imageUrl == null)
                            Text('Henüz bir fotoğraf yüklenmedi.',
                                style: GoogleFonts.inter(
                                    fontSize: 18, fontWeight: FontWeight.bold))
                          // edit modunda
                          else if (isEditing)
                            MyImagePicker(
                              onImageSelected: (file) {
                                setState(() {
                                  _selectedImage = file;
                                });
                              },
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
                    const Icon(Icons.local_hospital),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Klinik Adı:',
                            style: GoogleFonts.inter(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          isEditing
                              ? TextFormField(
                                  controller: clinicNameController,
                                  decoration: const InputDecoration(
                                    hintText: "Klinik Adı",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                  ),
                                )
                              : Text(
                                  clinicNameController.text,
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
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adres:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          isEditing
                              ? TextFormField(
                                  controller: addressController,
                                  decoration: const InputDecoration(
                                    hintText: "Klinik Adresi",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                  ),
                                )
                              : Text(
                                  addressController.text,
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
                          Text('İletişim:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          isEditing
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: phoneController,
                                      decoration: const InputDecoration(
                                        hintText: "Telefon",
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        hintText: "E-posta",
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Telefon: ${phoneController.text}',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16)),
                                    const SizedBox(height: 8),
                                    Text('E-posta: ${emailController.text}',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        )),
                                  ],
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
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Çalışma Saatleri:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          isEditing
                              ? TextFormField(
                                  controller: hoursController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: "Çalışma Saatleri",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                  ),
                                )
                              : Text(
                                  hoursController.text,
                                  style: const TextStyle(fontSize: 16),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isEditing) {
              saveClinicInfo();
            }
            // Basıldığında isEditing bool durumu tersine dönsün
            isEditing = !isEditing;
          });
        },
        child: Icon(isEditing ? Icons.save : Icons.edit),
      ),
    );
  }
}
