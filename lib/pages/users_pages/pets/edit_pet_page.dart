import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'dart:io';

import '../../../components/my_textformfield.dart';
import '../../../services/user_infos/pets_services.dart';
import '../../../widgets/image_picker.dart';

class EditPetPage extends StatefulWidget {
  final String petId;

  const EditPetPage({super.key, required this.petId});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  final firebaseService = PetFirebaseServices();
  late DocumentSnapshot petInfo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  File? image;

  @override
  void initState() {
    super.initState();
    loadPetInfo();
  }

  // Bilgileri al
  Future<void> loadPetInfo() async {
    petInfo = await firebaseService.getPetInfo(widget.petId);

    setState(() {
      nameController.text = petInfo['petName'];
      typeController.text = petInfo['petType'];
      ageController.text = petInfo['petAge'].toString();
    });
  }

  Future<void> updatePetInfo() async {
    String? imageUrl;

    // Yeni fotoğraf koyulursa yükle ve urlsini al
    if (image != null) {
      imageUrl = await firebaseService.uploadPetImage(image!);
    }

    // Bilgileri güncelle
    await firebaseService.updatePetList(widget.petId, {
      'petName': nameController.text,
      'petType': typeController.text,
      'petAge': int.parse(ageController.text),
      'petUrl': imageUrl ?? petInfo['petUrl'],
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyImagePicker(
              onImageSelected: (selectedImage) {
                setState(() {
                  image = selectedImage;
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),
            MyTextFormField(
              controller: nameController,
              hintText: "Hayvan Adı",
              obscureText: false,
            ),
            const SizedBox(
              height: 30,
            ),
            MyTextFormField(
              controller: typeController,
              hintText: "Hayvan Türü",
              obscureText: false,
            ),
            const SizedBox(
              height: 30,
            ),
            MyTextFormField(
              controller: ageController,
              hintText: "Hayvan Yaşı",
              obscureText: false,
              keyboarType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            MyButton(
              onPressed: updatePetInfo,
              text: "Güncelle",
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
