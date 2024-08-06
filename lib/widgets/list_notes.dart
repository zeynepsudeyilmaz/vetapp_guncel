import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListNotes extends StatefulWidget {
  const ListNotes({super.key});

  @override
  State<ListNotes> createState() => _ListNotesState();
}

class _ListNotesState extends State<ListNotes> {
  Stream<QuerySnapshot> listNotes() {
    return FirebaseFirestore.instance
        .collection("vets")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: listNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Bir hata oluştu"),
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List notes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final noteData = notes[index];
                final String note = noteData["note"];
                final Timestamp time = noteData["timestamp"];
                DateTime date = time.toDate();

                return ListTile(
                  title: const Text("Not"),
                  subtitle: Text("$note\n\n$date"),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Henüz bir not eklemediniz..."),
            );
          }
        },
      ),
    );
  }
}
