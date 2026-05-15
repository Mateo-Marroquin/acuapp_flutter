import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/constants/colors.dart';
import 'package:acuapp/api/marine_specie.dart';
import 'package:acuapp/widgets/specie_card.dart';
import 'package:acuapp/details.dart';
import 'package:acuapp/services/api_service.dart';
import 'dart:ui';
import 'package:acuapp/data/user_preferences.dart';
import 'package:acuapp/data/species_repository.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final UserPreferences _prefs = UserPreferences();
  final SpeciesRepository _repository = SpeciesRepository();
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<MarineSpecie> _searchResults = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _apiService.searchSpecies(query);
      setState(() {
        _searchResults = results.map((s) => _repository.syncSpecie(s)).toList();
      });
    } catch (e) {
      print('Error buscando: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _prefs,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(gradient: AppColors.mainGradient(_prefs.isDarkMode)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'Buscar Especies',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor(_prefs.isDarkMode),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardColor(_prefs.isDarkMode),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.textColor(_prefs.isDarkMode).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.montserrat(color: AppColors.textColor(_prefs.isDarkMode)),
                          decoration: InputDecoration(
                            hintText: 'Ingresa el nombre de la especie...',
                            hintStyle: GoogleFonts.montserrat(color: AppColors.subTextColor(_prefs.isDarkMode)),
                            prefixIcon: Icon(Icons.search, color: AppColors.subTextColor(_prefs.isDarkMode)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onSubmitted: _onSearchChanged,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: AppColors.textColor(_prefs.isDarkMode)))
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 120),
                          children: [
                            if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Center(
                                  child: Text(
                                    'No se encontraron resultados',
                                    style: GoogleFonts.montserrat(color: AppColors.subTextColor(_prefs.isDarkMode)),
                                  ),
                                ),
                              )
                            else if (_searchResults.isNotEmpty)
                              ..._searchResults.map((specie) => SpecieCard(
                                imageUrl: specie.imageUrl,
                                title: specie.commonName,
                                subtitle: specie.scientificName,
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(child: CircularProgressIndicator()),
                                  );
                                  try {
                                    if (specie.description == 'Cargando descripción...') {
                                      final wikiData = await ApiService().fetchWikipedia(specie.scientificName);
                                      setState(() {
                                        specie.description = wikiData['description'] ?? 'Sin descripción.';
                                        specie.imageUrl = wikiData['imageUrl'] ?? 'https://picsum.photos/seed/${specie.scientificName}/200';
                                      });
                                    }
                                  } catch (e) {
                                    print("Error al cargar Wikipedia: $e");
                                  } finally {
                                    Navigator.pop(context);
                                  }
                                  if (mounted) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Details(specie: specie),
                                      ),
                                    );
                                    setState(() {});
                                  }
                                },
                              )),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
