import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/constants/colors.dart';
import 'dart:ui';
import 'package:acuapp/data/user_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final UserPreferences _prefs = UserPreferences();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _prefs,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(gradient: AppColors.mainGradient(_prefs.isDarkMode)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Ajustes',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor(_prefs.isDarkMode),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.textColor(_prefs.isDarkMode)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Tema de la aplicación',
                    subtitle: _prefs.isDarkMode ? 'Modo Oscuro' : 'Modo Claro',
                    isDarkMode: _prefs.isDarkMode,
                    trailing: Switch(
                      value: _prefs.isDarkMode,
                      activeColor: AppColors.color4,
                      onChanged: (value) {
                        _prefs.isDarkMode = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required bool isDarkMode,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardColor(isDarkMode),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.textColor(isDarkMode).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.textColor(isDarkMode).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.textColor(isDarkMode)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        color: AppColors.textColor(isDarkMode),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.montserrat(
                        color: AppColors.subTextColor(isDarkMode),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
