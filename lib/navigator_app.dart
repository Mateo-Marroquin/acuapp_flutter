import 'package:flutter/material.dart';
import 'package:acuapp/explore.dart';
import 'package:acuapp/search.dart';
import 'package:acuapp/profile.dart';
import 'dart:ui';
import 'package:acuapp/constants/colors.dart';
import 'package:acuapp/data/user_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 85,
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? Colors.black.withOpacity(0.5) 
                        : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: AppColors.textColor(isDarkMode).withOpacity(0.15),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.explore_outlined, Icons.explore, 'Explorar', isDarkMode),
                      _buildNavItem(1, Icons.search_outlined, Icons.search, 'Buscar', isDarkMode),
                      _buildNavItem(2, Icons.person_outline, Icons.person, 'Perfil', isDarkMode),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, bool isDarkMode) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.textColor(isDarkMode).withOpacity(0.12) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.textColor(isDarkMode) : AppColors.subTextColor(isDarkMode),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.textColor(isDarkMode) : AppColors.subTextColor(isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
