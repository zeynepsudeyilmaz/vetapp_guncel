import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../components/my_button.dart';
import '../users_pages/log/login_or_register.dart';
import '../users_pages/log/register_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E5FA),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network(
                  "https://lottie.host/36a68c65-7902-4646-a045-be486e1eb51d/HQKwJAdQOV.json",
                  height: 200),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Merhaba!",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Veterinerler bir tık uzağında!",
                style: GoogleFonts.inter(fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              MyButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                text: "HADİ BAŞLAYALIM",
                fontSize: 20,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Zaten bir hesabın var mı?",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginorRegister()));
                    },
                    child: Text(
                      "Giriş yap",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF757EFA)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
