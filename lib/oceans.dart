import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/constants/colors.dart';
import 'package:acuapp/api/marine_specie.dart';
import 'package:acuapp/widgets/specie_card.dart';
import 'package:acuapp/details.dart';
import 'package:acuapp/data/species_repository.dart';
import 'package:acuapp/data/user_preferences.dart';
import 'dart:ui';

class Oceano extends StatefulWidget {
  final String oceanName;
  const Oceano({super.key, required this.oceanName});

  @override
  State<Oceano> createState() => _OceanoState();
}

class _OceanoState extends State<Oceano> {
  final SpeciesRepository _repository = SpeciesRepository();
  final UserPreferences _prefs = UserPreferences();
  List<MarineSpecie> _oceanSpecies = [];

  @override
  void initState() {
    super.initState();
    _loadOceanSpecies();
  }

  void _loadOceanSpecies() {
    setState(() {
      _oceanSpecies = _repository.getRandomSpecies(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _prefs,
      builder: (context, child) {
        final isDarkMode = _prefs.isDarkMode;
        return Container(
          decoration: BoxDecoration(gradient: AppColors.mainGradient(isDarkMode)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isDarkMode 
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.5),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back, 
                              color: AppColors.textColor(isDarkMode),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Océano ${widget.oceanName}',
                            style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor(isDarkMode),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Especies detectadas en esta región',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: AppColors.subTextColor(isDarkMode),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _oceanSpecies.isEmpty
                        ? Center(
                            child: Text(
                              'No hay datos suficientes para esta región',
                              style: GoogleFonts.montserrat(
                                color: AppColors.subTextColor(isDarkMode),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: _oceanSpecies.length,
                            itemBuilder: (context, index) {
                              final specie = _oceanSpecies[index];
                              return SpecieCard(
                                imageUrl: specie.imageUrl,
                                title: specie.commonName,
                                subtitle: specie.scientificName,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Details(specie: specie),
                                    ),
                                  );
                                },
                              );
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
}
