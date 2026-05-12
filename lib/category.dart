import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/ocean_card.dart';
import 'constants/colors.dart';

class Category extends StatefulWidget {
  final String title;
  const Category({super.key, required this.title});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                widget.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                OceanCard(imageUrl: 'assets/clownFish.jpg', title: 'Pez Payaso', subtitle: 'Astropicus')

              ],
            ),
          ),
        ),
      ),
    );
  }
}
