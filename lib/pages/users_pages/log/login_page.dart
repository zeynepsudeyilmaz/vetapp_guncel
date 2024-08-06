import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:veteriner_uygulamasi/helper/helper_functions.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/log/register_page.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/log/reset_password.dart';
import 'package:veteriner_uygulamasi/widgets/user_curved_bottom_nav_bar.dart';
import 'package:veteriner_uygulamasi/widgets/vet_curved_bottom_nav_bar.dart';

import '../../../components/my_button.dart';
import '../../../components/my_textformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});

  final void Function()? onTap;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Şifre görünürlüğü
  void togglePassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  // Kullanıcı giriş işlemi
  void signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Loading circle gösterme
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Giriş işlemi
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // E-posta adresine göre yönlendirme
        String collection =
            emailController.text.endsWith('@veteriner.com') ? 'vets' : 'users';

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(collection)
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();

        if (userDoc.exists) {
          // Sayfa yönlendirmesi
          if (collection == 'vets') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VetCurvedBottomNavBar()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserCurvedBottomNavBar()),
            );
          }
        } else {
          displayMessageToUser("Kullanıcı bulunamadı.", context);
        }
      } on FirebaseAuthException catch (e) {
        // Loading circle'ı kapat
        Navigator.pop(context);
        // Hata kontrolleri
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "Geçersiz e-posta adresi";
            break;
          case 'user-not-found':
            errorMessage = "Bu e-postaya ait bir hesap bulunamadı!";
            break;
          case 'wrong-password':
            errorMessage = "Girilen şifre yanlış";
            break;
          default:
            errorMessage = "Bir hata oluştu.";
            break;
        }
        displayMessageToUser(errorMessage, context);
      }
    }
  }

  // Google ile giriş metodu
  Future<void> signInWithGoogle(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Navigator.pop(context);
        displayMessageToUser("Google ile giriş yapılmadı", context);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // E-posta adresine göre yönlendirme
      String collection =
          FirebaseAuth.instance.currentUser!.email!.endsWith('@veteriner.com')
              ? 'vets'
              : 'users';

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(collection)
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      Navigator.pop(context);

      if (userDoc.exists) {
        // Sayfa yönlendirmesi
        if (collection == 'vets') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const VetCurvedBottomNavBar()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UserCurvedBottomNavBar()),
          );
        }
      } else {
        displayMessageToUser("Kullanıcı bulunamadı.", context);
      }
    } catch (e) {
      Navigator.pop(context);
      displayMessageToUser(
          "Google ile giriş yapılamadı: ${e.toString()}", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/images/dog.png"),
                    fit: BoxFit.fitHeight),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " PAW WORLD",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      prefixIcon: const Icon(Icons.email),
                      controller: emailController,
                      hintText: "E-posta",
                      obscureText: false,
                      validator: (data) {
                        if (data == null || data.isEmpty) {
                          return 'E-posta boş bırakılamaz';
                        }
                        final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!regex.hasMatch(data)) {
                          return 'Lütfen geçerli bir e-posta adresi girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    MyTextFormField(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: togglePassword,
                      ),
                      controller: passwordController,
                      obscureText: obscureText,
                      hintText: "Şifre",
                      validator: (data) {
                        if (data == null || data.isEmpty) {
                          return 'Şifre boş bırakılamaz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Text(
                            "Şifreni mi unuttun?",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ResetPasswordPage()));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      text: "Giriş Yap",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      onPressed: () => signIn(context),
                    ),
                    const SizedBox(height: 40),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFF66D0A4),
                          ),
                        ),
                        Text(
                          "    ya da şununla giriş yap    ",
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Color(0xFF66D0A4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    MyButton(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      backgroundColor: const Color(0xFF66D0A4),
                      text: "Google ile Giriş Yap",
                      imagePath: "lib/images/google.png",
                      onPressed: () => signInWithGoogle(context),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hesabın yok mu?",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Kayıt ol",
                            style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
