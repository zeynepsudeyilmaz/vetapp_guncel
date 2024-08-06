import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../services/user_infos/pets_services.dart';
import 'add_pet_page.dart';
import 'edit_pet_page.dart';

class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  final firebaseService = PetFirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: firebaseService.listPets(),
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
                List petsList = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: petsList.length,
                  itemBuilder: (context, index) {
                    final pet = petsList[index];
                    final petName = pet["petName"];
                    final petType = pet['petType'];
                    final petAge = pet['petAge'];
                    final petUrl = pet['petUrl'];

                    return Slidable(
                      startActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            firebaseService.deletePet(pet.id);
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
                                        EditPetPage(petId: pet.id)));
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: "Düzenle",
                        ),
                      ]),
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
                            backgroundImage: NetworkImage(petUrl),
                          ),
                          title: Row(
                            children: [
                              Text(
                                "İsim: $petName,",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "yaş: $petAge",
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "Tür: $petType",
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              // hayvan bilgisi yoksa
              else {
                return const Center(child: Text("Hiç hayvan eklenmedi..."));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddToPetPage(),
            ),
          );
          //güncelleme yapıldıysa veriyi tekrar yükle
          if (result == true) {
            setState(() {});
          }
        },
        tooltip: "Hayvan Ekle",
        splashColor: Colors.deepPurple[200],
        child: const Icon(Icons.add),
      ),
    );
  }
}
