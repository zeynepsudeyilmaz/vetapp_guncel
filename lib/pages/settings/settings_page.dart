import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veteriner_uygulamasi/components/my_button.dart';

import '../../helper/helper_functions.dart';
import '../../services/user_infos/user_services.dart';
import '../users_pages/account/change_password.dart';
import '../users_pages/log/login_or_register.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isToggleEnabled = false;
  bool isDarkMode = false;
  void deleteUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      //loading circle
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Kullanıcıyı veritabanından sil
      final firebaseService = UserFirebaseServices();
      await firebaseService.userInfo.delete();

      // Kullanıcıyı sil
      await user?.delete();

      displayMessageToUser("Hesabınız başarıyla silindi", context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginorRegister()),
      );
    } on FirebaseAuthException catch (e) {
      displayMessageToUser(e.message!, context);
    } catch (e) {
      displayMessageToUser("Bir hata oluştu. Lütfen tekrar deneyin.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE3E5FA),
        body: SafeArea(
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                title: Text(
                  "Bildirimler",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                trailing: Switch(
                  value: isToggleEnabled,
                  onChanged: (bool value) {
                    //bildirim izni
                    if (value) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Bildirimlere izin ver",
                                style: GoogleFonts.inter(),
                              ),
                              content: Text(
                                "Uygulamamız, en güncel bilgiler ve fırsatlar için bildirim göndermektedir. Bildirimleri açarak, önemli güncellemeleri ve hatırlatmaları anında alabilirsiniz.\n\nBildirimleri açmak için izninizi vermeniz gerekmektedir. İzin veriyor musunuz? ",
                                style: GoogleFonts.inter(),
                              ),
                              actions: [
                                MyButton(
                                    text: "Evet",
                                    onPressed: () {
                                      setState(() {
                                        isToggleEnabled = true;
                                        Navigator.of(context).pop();
                                      });
                                    }),
                                MyButton(
                                    text: "Hayır",
                                    onPressed: () {
                                      setState(() {
                                        isToggleEnabled = false;
                                        Navigator.of(context).pop();
                                      });
                                    })
                              ],
                            );
                          });
                    } else {
                      //tekrar bildirimleri kapatmak isterse durumu güncelle
                      setState(() {
                        isToggleEnabled = false;
                      });
                    }
                  },
                ),
                subtitle: Text(
                  "Bildirimlere izin ver",
                  style: GoogleFonts.inter(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text("Tema",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
                subtitle: Text(
                  "Uygulama temasını özelleştirin",
                  style: GoogleFonts.inter(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text("Şifremi Değiştir",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePassword()));
                },
                subtitle: Text(
                  "Hesabınızın şifresini değiştirin",
                  style: GoogleFonts.inter(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text("Hesabımı Sil",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Hesabımı Sil",
                            style: GoogleFonts.inter(),
                          ),
                          content: Text(
                            "Hesabınızı silmek istediğinize emin misiniz?",
                            style: GoogleFonts.inter(),
                          ),
                          actions: [
                            MyButton(
                                text: "Evet",
                                onPressed: () {
                                  deleteUser();
                                }),
                            MyButton(
                                text: "Hayır",
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        );
                      });
                },
                subtitle: Text(
                  "Hesabınızın silin",
                  style: GoogleFonts.inter(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ));
  }
}
