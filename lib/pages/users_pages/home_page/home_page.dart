import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/home_page/map.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/pets/add_pet_page.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/vets/vets_details_pages.dart';
import '../../../services/user_infos/pets_services.dart';
import '../log/login_or_register.dart';
import '../pets/my_pets_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  final firebaseService = PetFirebaseServices();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (userInfo.exists) {
        setState(() {
          username = userInfo["name"];
        });
      }
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FA),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selam, $username!",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            logout();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginorRegister(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FA),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Evcil Hayvanlarım",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            MyButton(
                              text: "Hepsini Gör",
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyPetsPage(),
                                  ),
                                );
                              },
                              fontSize: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddToPetPage(),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF9CA8FB),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Ekle",
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              StreamBuilder<QuerySnapshot>(
                                stream: firebaseService.listPets(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (snapshot.hasError) {
                                    return const Text("Bir hata oluştu.");
                                  }

                                  final petsList = snapshot.data?.docs;

                                  if (petsList != null && petsList.isNotEmpty) {
                                    return Row(
                                      children: petsList.map((pet) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: SizedBox(
                                                  width: 75,
                                                  height: 75,
                                                  child: Image.network(
                                                    pet['petUrl'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                pet['petName'],
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FA),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Veteriner Konumları",
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        MapScreen()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  " Veterinerler",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 350,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('vets')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text("Bir hata oluştu."));
                      }

                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        final vetList = snapshot.data!.docs;

                        return Row(
                          children: vetList.map((vet) {
                            final vetId = vet.id;
                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('vets')
                                  .doc(vetId)
                                  .collection('clinicInfo')
                                  .doc('info')
                                  .snapshots(),
                              builder: (context, clinicSnapshot) {
                                if (clinicSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 150,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                if (clinicSnapshot.hasError) {
                                  return const SizedBox(
                                    width: 150,
                                    child: Center(
                                        child:
                                            Text("Bilinmeyen bir hata oluştu")),
                                  );
                                }

                                if (!clinicSnapshot.hasData ||
                                    !clinicSnapshot.data!.exists) {
                                  return const SizedBox(
                                    width: 150,
                                    child: Center(
                                        child: Text(
                                            'Veteriner bilgisi bulunamadı.')),
                                  );
                                }

                                final clinicData = clinicSnapshot.data!.data()
                                    as Map<String, dynamic>;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VetDetailsPage(vetId: vetId)));
                                  },
                                  child: SizedBox(
                                    width: 250,
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            ),
                                            child: SizedBox(
                                              height: 160,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image.network(
                                                clinicData['imageUrl'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.local_hospital),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        clinicData[
                                                            'companyName'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        clinicData[
                                                            'companyAddress'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 3,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const Center(
                            child: Text("Veteriner bilgisi bulunamadı"));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
