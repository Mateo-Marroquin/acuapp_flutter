import 'package:flutter/material.dart';
import 'package:acuapp/explore.dart';
import 'package:acuapp/search.dart';
import 'package:acuapp/profile.dart';
import 'dart:ui';
import 'package:acuapp/constants/colors.dart';
import 'package:acuapp/data/user_preferences.dart';

class NavigatorApp extends StatefulWidget {
  const NavigatorApp({super.key});

  @override
  State<NavigatorApp> createState() => _NavigatorAppState();
}

class _NavigatorAppState extends State<NavigatorApp> {
  int _selectedIndex = 0;
  final UserPreferences _prefs = UserPreferences();

  final List<Widget> _pages = [
    const Explore(),
    const Search(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _prefs,
      builder: (context, child) {
        final isDarkMode = _prefs.isDarkMode;
        return Scaffold(
          extendBody: true,
          body: _pages[_selectedIndex],
          bottomNavigationBar: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 10),
                child: Container(
                  height: 95,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor(isDarkMode),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.textColor(isDarkMode).withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                      iconSize: 22,
                      backgroundColor: Colors.transparent,
                      currentIndex: _selectedIndex,
                      selectedItemColor: AppColors.textColor(isDarkMode),
                      unselectedItemColor: AppColors.subTextColor(isDarkMode),
                      showSelectedLabels: true,
                      showUnselectedLabels: false,
                      selectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        height: 1,
                      ),
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.explore_outlined),
                          activeIcon: Icon(Icons.explore),
                          label: 'Explorar',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.search_outlined),
                          activeIcon: Icon(Icons.search),
                          label: 'Buscar',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_outline),
                          activeIcon: Icon(Icons.person),
                          label: 'Perfil',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
