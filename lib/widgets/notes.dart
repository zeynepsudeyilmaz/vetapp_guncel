import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'package:veteriner_uygulamasi/components/my_textformfield.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final TextEditingController _noteController = TextEditingController();

  // firestore ekleme
  void saveNote() async {
    String note = _noteController.text;
    await FirebaseFirestore.instance
        .collection("vets")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notes")
        .add({
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Not başarıyla kaydedildi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FA),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyTextFormField(
                obscureText: false,
                controller: _noteController,
                hintText: "Notunuzu buraya yazın",
              ),
              const SizedBox(height: 16),
              MyButton(
                onPressed: saveNote,
                text: "Notu Kaydet",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
