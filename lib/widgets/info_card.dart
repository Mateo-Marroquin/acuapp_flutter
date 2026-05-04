import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/constants/colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const InfoCard({super.key, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.color1.withOpacity(0.8),
          borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.color5),
              Text(title, style: TextStyle(color: AppColors.color5)),
            ],
          ),
          Text(subtitle, style: TextStyle(color: AppColors.color5)),
        ],
      ),
    );
  }
}
