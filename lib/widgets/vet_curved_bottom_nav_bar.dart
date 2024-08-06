import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:veteriner_uygulamasi/pages/settings/settings_page.dart';
import 'package:veteriner_uygulamasi/pages/vets_pages/appointments/vet_appointments.dart';
import 'package:veteriner_uygulamasi/pages/vets_pages/clinic_infos/clinic_infos.dart';
import 'package:veteriner_uygulamasi/pages/vets_pages/home_page/vet_home_page.dart';
import 'package:veteriner_uygulamasi/pages/vets_pages/products/products.dart';

class VetCurvedBottomNavBar extends StatefulWidget {
  const VetCurvedBottomNavBar({super.key});

  @override
  State<VetCurvedBottomNavBar> createState() => _VetCurvedBottomNavBarState();
}

class _VetCurvedBottomNavBarState extends State<VetCurvedBottomNavBar> {
  int selectedIndex = 2;

  List pages = [
    const ClinicInfos(),
    const Products(),
    const VetHomePage(),
    const VetAppointments(),
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
              Icons.medical_services,
              color: Colors.white,
            ),
            Icon(
              Icons.inventory,
              color: Colors.white,
            ),
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Icon(
              Icons.calendar_today,
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
