import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/pages/patient/settings.dart';
import 'package:esma3ny/ui/pages/patient/upcomin_session_page.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import 'Profile.dart';
import 'therapists.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  PublicRepository _publicRepository = PublicRepository();

  List screens = [
    // HomeClient(),
    TherapistsList(),
    UpComingSessions(),
    Profile(),
    SettingsPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  initialCalls() async {
    await _publicRepository.getSpcializations();
    await _publicRepository.getLanguages();
    await _publicRepository.getJob();
  }

  @override
  void initState() {
    initialCalls();
    super.initState();
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
          FloatingNavbarItem(icon: Icons.group, title: 'Thirapists'),
          FloatingNavbarItem(icon: Icons.notifications, title: 'Sessions'),
          FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
          FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        ],
      ),
    );
  }
}
