import 'package:acuapp/widgets/category_header.dart';
import 'package:acuapp/widgets/info_card.dart';
import 'package:acuapp/widgets/ocean_card.dart';
import 'package:flutter/material.dart';

import 'constants/colors.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                CategoryHeader(
                  imageUrl: 'assets/clownFish.jpg',
                  title: 'Pez Payaso',
                  subtitle: 'Picious Payasous',
                  yOffset: 0.1,
                ),
                InfoCard(
                  icon: Icons.fastfood_outlined,
                  title: 'Descripción:',
                  subtitle:
                      'El pez payaso es un pez payaso, que es un pez payaso, que es un pez payaso, que es un pez payaso, que es un pez payaso, que es un pez payaso, que es un pez payaso, que es un pez payaso, que es un pez payaso, que es un pez payaso,',
                ),
                InfoCard(
                  icon: Icons.fastfood_outlined,
                  title: 'Alimentación:',
                  subtitle: 'Plankton',
                ),
                InfoCard(
                  icon: Icons.fastfood_outlined,
                  title: 'Hábitat:',
                  subtitle: 'Oceano Pacífico',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
