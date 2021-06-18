import 'package:esma3ny/ui/pages/comming_soon.dart';
import 'package:esma3ny/ui/pages/doctor/profile.dart';
import 'package:esma3ny/ui/pages/patient/settings.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class TherapistBottomNavBar extends StatefulWidget {
  @override
  _TherapistBottomNavBarState createState() => _TherapistBottomNavBarState();
}

class _TherapistBottomNavBarState extends State<TherapistBottomNavBar> {
  int _selectedIndex = 0;

  List screens = [
    // HomeClient(),
    CommingSoon(),
    CommingSoon(),
    TherapistProfilePage(),
    SettingsPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[_selectedIndex],
      bottomNavigationBar: FloatingNavbar(
        onTap: _onItemTapped,
        borderRadius: 50,
        backgroundColor: CustomColors.blue,
        selectedBackgroundColor: CustomColors.blue,
        selectedItemColor: CustomColors.white,
        unselectedItemColor: CustomColors.lightBlue,
        currentIndex: _selectedIndex,
        items: [
          // FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.group, title: 'Appointments'),
          FloatingNavbarItem(icon: Icons.monetization_on, title: 'Invoices'),
          FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
          FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        ],
      ),
    );
  }
}
