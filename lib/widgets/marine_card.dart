import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            color: Colors.blueGrey,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.8),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}