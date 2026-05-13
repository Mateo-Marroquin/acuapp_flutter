import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryHeader extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String subtitle;
  final double? yOffset;

  const CategoryHeader({
    super.key,
    this.imageUrl,
    required this.title,
    required this.subtitle,
    this.yOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.blueGrey),
      child: Stack(
        children: [
          if (imageUrl != null)
            Positioned.fill(
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                alignment: Alignment(yOffset ?? 0.0, 0.0),
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://picsum.photos/110/110',
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
