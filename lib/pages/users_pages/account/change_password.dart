import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';

import '../../../helper/helper_functions.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Şifre kontrolü
  void changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      displayMessageToUser("Yeni şifreler eşleşmiyor!", context);
      return;
    }

    try {
      User user = FirebaseAuth.instance.currentUser!;

      // Mevcut şifreyi doğrula
      String email = user.email!;
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Yeni şifreyi güncelle
      await user.updatePassword(newPasswordController.text);

      displayMessageToUser("Şifre başarıyla güncellendi!", context);
    } on FirebaseAuthException catch (e) {
      displayMessageToUser(e.message!, context);
    } catch (e) {
      displayMessageToUser("Bir hata oluştu. Lütfen tekrar deneyin.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      backgroundColor: const Color(0xFFE3E5FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                hintText: "Mevcut Şifre",
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                hintText: "Yeni Şifre",
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                hintText: "Yeni Şifre (Tekrar)",
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            MyButton(
              onPressed: changePassword,
              text: "Şifreyi Değiştir",
            ),
          ],
        ),
      ),
    );
  }
}
