import 'package:acuapp/widgets/category_header.dart';
import 'package:acuapp/widgets/info_card.dart';
import 'package:flutter/material.dart';

import 'constants/colors.dart';

class Details extends StatefulWidget {
  final String scientificName;
  final String commonName;
  final String order;
  final String threatStatus;
  final String description;
  final String imageUrl;

  const Details({super.key, required this.scientificName, required this.commonName, required this.order, required this.threatStatus, required this.description, required this.imageUrl});

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
                  imageUrl: widget.imageUrl,
                  title: widget.commonName,
                  subtitle: widget.scientificName,
                  yOffset: 0.1,
                ),
                InfoCard(
                  icon: Icons.fastfood_outlined,
                  title: 'Descripción:',
                  subtitle: widget.description,
                ),
                InfoCard(
                  icon: Icons.fastfood_outlined,
                  title: 'Orden:',
                  subtitle: widget.order,
                ),
                InfoCard(
                  icon: Icons.fastfood_outlined,
                  title: 'Estado de amenaza:',
                  subtitle: widget.threatStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
