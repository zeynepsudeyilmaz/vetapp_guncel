import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veteriner_uygulamasi/pages/vets_pages/products/add_product.dart';
import 'package:veteriner_uygulamasi/pages/vets_pages/products/edit_product.dart';
import '../../../services/products/products-services.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final firebaseService = ProductFirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: firebaseService.listProducts(),
            builder: (context, snapshot) {
              // Hata kontrolü
              if (snapshot.hasError) {
                return const Center(child: Text("Bir hata oluştu."));
              }
              // Veriler yükleniyorsa loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Ürün varsa
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

                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              firebaseService.deleteProduct(product.id);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: "Sil",
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProduct(productId: product.id),
                                ),
                              );
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: "Düzenle",
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF757EFA),
                          borderRadius: BorderRadius.circular(16),
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
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "Adet: $productCount",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Fiyat: $productPrice ₺",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              // Ürün yoksa
              else {
                return const Center(child: Text("Hiç ürün eklenmedi..."));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProduct(),
            ),
          );
        },
        tooltip: "Ürün Ekle",
        splashColor: Colors.deepPurple[200],
        child: const Icon(Icons.add),
      ),
    );
  }
}
