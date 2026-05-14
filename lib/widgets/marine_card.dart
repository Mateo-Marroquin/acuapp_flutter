import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/data/user_preferences.dart';
import 'package:acuapp/constants/colors.dart';

class MarineCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final double yOffset;
  final VoidCallback? onTap;

  const MarineCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.yOffset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();
    return ListenableBuilder(
      listenable: prefs,
      builder: (context, child) {
        final isDarkMode = prefs.isDarkMode;
        return Card(
          color: AppColors.cardColor(isDarkMode),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: AppColors.textColor(isDarkMode).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 160,
              width: 140,
              decoration: BoxDecoration(
                image: imageUrl != null
                    ? DecorationImage(
                        image: AssetImage(imageUrl!),
                        fit: BoxFit.cover,
                        alignment: Alignment(yOffset, 0.0),
                      )
                    : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
