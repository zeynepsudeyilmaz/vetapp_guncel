import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/helper/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../services/products/products-services.dart';
import '../../../widgets/image_picker.dart';

class Products {
  String name;
  double price;
  File img;
  int count;

  Products({
    required this.name,
    required this.price,
    required this.img,
    required this.count,
  });
}

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController countController = TextEditingController();

  File? _selectedImage;

  Future<void> saveProduct() async {
    if (_selectedImage == null) {
      // resim yoksa uyarı mesajı yolla
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir resim seçin')),
      );
      return;
    }
    // Resmi storage'a yükle
    try {
      // görselin dosya yolunu al
      String fileName = path.basename(_selectedImage!.path);
      // products klasörünü oluştur
      Reference storageRef =
          FirebaseStorage.instance.ref().child('products/$fileName');
      // resmi bu dosyaya yükle
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      TaskSnapshot taskSnapshot = await uploadTask;
      // görselin  urlsini al
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Ürün bilgilerini firestore'a kaydet
      final firebaseService = ProductFirebaseServices();

      String productName = nameController.text;
      double? productPrice = double.tryParse(priceController.text);
      int? productCount = int.tryParse(countController.text);

      await firebaseService.addProducts(
        productName: productName,
        productPrice: productPrice!,
        productCount: productCount!,
        productUrl: imageUrl,
      );

      // İşlem tamamlanınca formu sıfırla
      nameController.clear();
      priceController.clear();
      countController.clear();
      _selectedImage = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla eklendi')),
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
      appBar: AppBar(title: const Text("Ürün Ekle")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyImagePicker(
                onImageSelected: (img) {
                  _selectedImage = img;
                },
              ),
              const SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Ürün Adı",
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "Ürün Fiyatı",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: countController,
                decoration: const InputDecoration(
                  labelText: "Ürün Adedi",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveProduct,
                child: const Text("Ürün Ekle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
