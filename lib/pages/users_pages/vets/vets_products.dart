import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VetsProducts extends StatelessWidget {
  final String vetId;

  const VetsProducts({super.key, required this.vetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("vets")
            .doc(vetId)
            .collection("clinicInfo")
            .doc("info")
            .collection("products")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu."));
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List productsList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                final product = productsList[index];
                final productName = product['productName'];
                final productPrice = product['productPrice'];
                final productCount = product['productCount'];
                final productImgUrl = product['productUrl'];

                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(productImgUrl),
                    ),
                    title: Text(
                      "Ürün: $productName,",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          "Adet: $productCount",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Fiyat: $productPrice ₺",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Ürün bulunamadı."));
          }
        },
      ),
    );
  }
}
