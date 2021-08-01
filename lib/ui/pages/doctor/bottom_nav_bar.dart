import 'package:auto_size_text/auto_size_text.dart';
import 'package:esma3ny/ui/pages/doctor/appointments.dart';
import 'package:esma3ny/ui/pages/doctor/calender.dart';
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
    AppointmentsPage(),
    Calender(),
    TherapistProfilePage(),
    SettingsPage(),
  ];

  List<FloatingNavbarItem> items = [
    FloatingNavbarItem(icon: Icons.group, title: 'Appointments'),
    FloatingNavbarItem(icon: Icons.calendar_today, title: 'Calender'),
    FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
    FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
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
      body: SafeArea(
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
        itemBuilder: (context, item) => InkWell(
          onTap: () => _onItemTapped(items.indexOf(item)),
          child: Column(
            children: [
              Icon(
                item.icon,
                color: Colors.white,
              ),
              AutoSizeText(
                item.title,
                maxFontSize: 12,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        items: items,
      ),
    );
  }
}
