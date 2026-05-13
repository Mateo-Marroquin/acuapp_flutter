import 'package:acuapp/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'details.dart';
import 'widgets/specie_card.dart';
import 'constants/colors.dart';
import 'data/species_repository.dart';
import 'package:acuapp/constants/taxonIds.dart';

class Category extends StatefulWidget {
  final String title;
  const Category({super.key, required this.title});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final repository = SpeciesRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (repository.getSpeciesByCategory(widget.title).isEmpty) {
      cargarDatos();
    }
  }

  Future<void> cargarDatos() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    int taxonKey = oceanRegistry[widget.title] ?? 587;
    
    final nuevas = await ApiService().fetchRandomMarineSpecies(taxonKey, widget.title ,20);

    repository.updateCategory(widget.title, nuevas);

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: cargarDatos,
                  child: _isLoading
                      ? _buildShimmerList()
                      : _buildSpeciesList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesList() {
    final listaCategoria = repository.getSpeciesByCategory(widget.title);
    if (listaCategoria.isEmpty) {
      return const Center(
          child: Text(
              "No se encontraron especies",
              style: TextStyle(color: Colors.white)
          )
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: repository.getSpeciesByCategory(widget.title).length,
      itemBuilder: (context, index) {
        final pez = repository.getSpeciesByCategory(widget.title)[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: SpecieCard(
            title: pez.commonName,
            subtitle: pez.scientificName,
            imageUrl: pez.imageUrl,
            onTap: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              try {
                if (pez.description == 'Cargando descripción...') {
                  final wikiData = await ApiService().fetchWikipedia(pez.commonName);

                  setState(() {
                    pez.description = wikiData['description'] ?? 'Sin descripción.';
                    pez.imageUrl = wikiData['imageUrl'] ?? 'https://picsum.photos/seed/${pez.scientificName}/200';
                  });
                }
              } catch (e) {
                print("Error al cargar Wikipedia: $e");
              } finally {
                Navigator.pop(context);
              }

              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      imageUrl: pez.imageUrl,
                      scientificName: pez.scientificName,
                      commonName: pez.commonName,
                      description: pez.description,
                      order: pez.order,
                      threatStatus: pez.threatStatus,
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}