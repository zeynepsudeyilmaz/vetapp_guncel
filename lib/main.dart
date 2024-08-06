import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:veteriner_uygulamasi/pages/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting('tr_TR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
