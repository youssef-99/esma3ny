import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/pages/patient/settings.dart';
import 'package:esma3ny/ui/pages/patient/upcomin_session_page.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    // print(window.viewPadding);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: true,
        child: screens[_selectedIndex],
      ),
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
          FloatingNavbarItem(
            icon: Icons.group,
            title: AppLocalizations.of(context).therapists,
          ),
          FloatingNavbarItem(
            icon: Icons.notifications,
            title: AppLocalizations.of(context).sessions,
          ),
          FloatingNavbarItem(
            icon: Icons.person,
            title: AppLocalizations.of(context).profile,
          ),
          FloatingNavbarItem(
            icon: Icons.settings,
            title: AppLocalizations.of(context).settings,
          ),
        ],
      ),
    );
  }
}
