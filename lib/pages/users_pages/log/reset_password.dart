import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';
import 'package:veteriner_uygulamasi/components/my_textformfield.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Şifre sıfırlama metodu
  void resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre sıfırlama bağlantısı gönderildi!')),
      );
      Navigator.pop(context); // Geri dön
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == "user-nof-found") {
        errorMessage = "Bu e-postaya ait bir hesap bulunamadı!";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Geçersiz e-posta adresi!";
      } else {
        errorMessage = "Bilinmeyen bir hata oluştu";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'E-posta adresinizi girin',
                style: GoogleFonts.inter(fontSize: 20),
              ),
              const SizedBox(height: 20),
              MyTextFormField(
                controller: emailController,
                hintText: 'E-posta',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta boş bırakılamaz';
                  }
                  final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!regex.hasMatch(value)) {
                    return 'Lütfen geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              MyButton(
                onPressed: resetPassword,
                text: 'Şifre Sıfırla',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
