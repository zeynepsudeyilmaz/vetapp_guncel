import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veteriner_uygulamasi/components/my_textformfield.dart';
import 'package:veteriner_uygulamasi/helper/helper_functions.dart';
import '../../../components/my_button.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  final TextEditingController adController = TextEditingController();
  final TextEditingController soyadController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Şifre görünürlüğü
  void togglePassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  // Kullanıcı kaydı işlemi
  void registerUser() async {
    // Formun doğruluğunu kontrol et
    if (_formKey.currentState!.validate()) {
      // Loading circle
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Kullanıcı oluşturma
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Kullanıcı bilgisini alıp database'e ekleme
        await addUserInfo(
          userCredential.user!.uid,
          adController.text,
          soyadController.text,
          emailController.text,
        );

        Navigator.pop(context);
        // Login sayfasına yönlendirme
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        displayMessageToUser("Kayıt başarılı! Giriş yapabilirsiniz.", context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.message ?? "Bir hata oluştu", context);
      }
    }
  }

  // Kullanıcı bilgisini alıp database'e ekleme işlemi
  Future<void> addUserInfo(
      String uid, String name, String surname, String email) async {
    // E-posta adresine göre koleksiyonu belirle
    String collection =
        emailController.text.endsWith('@veteriner.com') ? 'vets' : 'users';

    // Kullanıcı bilgilerini belirlenen koleksiyona ekleme
    await FirebaseFirestore.instance.collection(collection).doc(uid).set({
      "name": name,
      "surname": surname,
      "email": email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E5FA),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/dog.png"),
                fit: BoxFit.contain,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Kayıt Ol",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(
                          prefixIcon: const Icon(Icons.person),
                          controller: adController,
                          hintText: "Ad",
                          obscureText: false,
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'Bu alan boş bırakılamaz';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextFormField(
                          prefixIcon: const Icon(Icons.person),
                          controller: soyadController,
                          hintText: "Soyad",
                          obscureText: false,
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'Bu alan boş bırakılamaz';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  MyTextFormField(
                    prefixIcon: const Icon(Icons.email),
                    controller: emailController,
                    hintText: "E-posta",
                    obscureText: false,
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Bu alan boş bırakılamaz';
                      }
                      final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!regex.hasMatch(data)) {
                        return 'Geçerli bir e-posta adresi girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextFormField(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: togglePassword,
                    ),
                    controller: passwordController,
                    hintText: "Şifre",
                    obscureText: obscureText,
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Bu alan boş bırakılamaz';
                      }
                      if (data.length < 6) {
                        return 'Şifre en az 6 karakter uzunluğunda olmalıdır';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextFormField(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: togglePassword,
                    ),
                    controller: confirmPasswordController,
                    hintText: "Şifreyi doğrula",
                    obscureText: obscureText,
                    validator: (data) {
                      if (data == null || data.isEmpty) {
                        return 'Bu alan boş bırakılamaz';
                      }
                      if (data != passwordController.text) {
                        return 'Şifreler eşleşmiyor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onPressed: () {
                      registerUser();
                    },
                    text: "Kayıt Ol",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hesabın mı var?",
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
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Giriş yap",
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
    );
  }
}
