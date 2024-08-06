import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'package:veteriner_uygulamasi/components/my_textformfield.dart';
import 'package:veteriner_uygulamasi/helper/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../services/user_infos/pets_services.dart';
import '../../../widgets/image_picker.dart';

class AddToPetPage extends StatefulWidget {
  const AddToPetPage({super.key});

  @override
  State<AddToPetPage> createState() => _AddToPetPageState();
}

class _AddToPetPageState extends State<AddToPetPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  File? _selectedImage;

  Future<void> savePet() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lütfen bir resim seçin',
            style: GoogleFonts.inter(),
          ),
        ),
      );
      return;
    }

    try {
      String fileName = path.basename(_selectedImage!.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('pets/$fileName');
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      final firebaseService = PetFirebaseServices();

      String petName = nameController.text;
      String petType = typeController.text;
      int? petAge = int.tryParse(ageController.text);

      await firebaseService.addPet(
        petName: petName,
        petType: petType,
        petAge: petAge!,
        petUrl: imageUrl,
      );

      nameController.clear();
      typeController.clear();
      ageController.clear();
      _selectedImage = null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Hayvan başarıyla eklendi',
          style: GoogleFonts.inter(),
        )),
      );
      Navigator.pop(context);
    } catch (e) {
      displayMessageToUser("Bir hata oluştu: $e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyImagePicker(
                onImageSelected: (img) {
                  setState(() {
                    _selectedImage = img;
                  });
                },
              ),
              const SizedBox(height: 30),
              MyTextFormField(
                controller: nameController,
                hintText: "Hayvan Adı",
                obscureText: false,
              ),
              const SizedBox(height: 30),
              MyTextFormField(
                controller: typeController,
                hintText: "Hayvan Türü",
                obscureText: false,
              ),
              const SizedBox(height: 30),
              MyTextFormField(
                controller: ageController,
                hintText: "Hayvan Yaşı",
                obscureText: false,
                keyboarType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              MyButton(
                onPressed: savePet,
                text: "Hayvan Ekle",
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
