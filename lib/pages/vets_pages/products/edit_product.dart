import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';

import '../../../services/products/products-services.dart';

class EditProduct extends StatefulWidget {
  final String productId;

  const EditProduct({super.key, required this.productId});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final firebaseService = ProductFirebaseServices();
  late DocumentSnapshot productInfo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  String? productUrl;
  @override
  void initState() {
    super.initState();
    loadProductInfo();
  }

  Future<void> loadProductInfo() async {
    productInfo = await firebaseService.getProductInfo(widget.productId);

    setState(() {
      nameController.text = productInfo['productName'];
      priceController.text = productInfo['productPrice'].toString();
      countController.text = productInfo['productCount'].toString();
      productUrl = productInfo['productUrl'];
    });
  }

  Future<void> updateProductInfo() async {
    await firebaseService.updateProductList(widget.productId, {
      'productName': nameController.text,
      'productPrice': double.parse(priceController.text),
      'productCount': int.parse(countController.text),
      'productImg': productUrl,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 25.0, right: 25.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Ürün Adı",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Ürün Fiyatı",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Ürün Adedi",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                onPressed: updateProductInfo,
                text: "Güncelle",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
