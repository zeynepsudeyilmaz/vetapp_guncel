import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';

class MyImagePicker extends StatefulWidget {
  final Function(File) onImageSelected;

  const MyImagePicker({super.key, required this.onImageSelected});

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File? _image;
  final picker = ImagePicker();

  // Galeriden fotoğraf seçme
  Future<void> getImageGallery() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        widget.onImageSelected(_image!);
      });
    }
  }

  // Kameradan fotoğraf çekme
  Future<void> getImageCamera() async {
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        widget.onImageSelected(_image!);
      });
    }
  }

  // fotoğraf ekleme dialog
  void showPhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Fotoğraf Ekle",
            style: GoogleFonts.inter(),
          ),
          content: Text(
            "Evcil hayvanınızın fotoğrafını ekleyin",
            style: GoogleFonts.inter(),
          ),
          actions: [
            MyButton(
              text: "Galeriden Seç",
              onPressed: () {
                Navigator.pop(context);
                getImageGallery();
              },
            ),
            MyButton(
              text: "Fotoğraf Çek",
              onPressed: () {
                Navigator.pop(context);
                getImageCamera();
              },
            ),
            MyButton(
              text: "İptal",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPhotoDialog(context),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[300],
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? const Icon(
                Icons.camera_alt,
                size: 40,
                color: Colors.grey,
              )
            : null,
      ),
    );
  }
}
