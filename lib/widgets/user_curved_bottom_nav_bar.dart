import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/appointments/appointments.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/home_page/home_page.dart';
import 'package:veteriner_uygulamasi/pages/users_pages/pets/my_pets_page.dart';
import 'package:veteriner_uygulamasi/pages/settings/settings_page.dart';

import '../pages/users_pages/account/my_account.dart';

class UserCurvedBottomNavBar extends StatefulWidget {
  const UserCurvedBottomNavBar({super.key});

  @override
  State<UserCurvedBottomNavBar> createState() => _UserCurvedBottomNavBarState();
}

class _UserCurvedBottomNavBarState extends State<UserCurvedBottomNavBar> {
  int selectedIndex = 2;

  List pages = [
    const MyPetsPage(),
    const Appointments(),
    const HomePage(),
    const MyAccountPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xFFE3E5FA),
          color: const Color(0xFF757EFA),
          index: selectedIndex,
          items: const [
            Icon(
              Icons.pets,
              color: Colors.white,
            ),
            Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Icon(
              Icons.person,
              color: Colors.white,
            ),
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ],
          onTap: (newIndex) {
            setState(() {
              selectedIndex = newIndex;
            });
          }),
      body: pages[selectedIndex],
    );
  }
}
