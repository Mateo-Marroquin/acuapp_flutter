import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/constants/colors.dart';
import 'package:acuapp/data/user_preferences.dart';

import 'api/marine_specie.dart';

class Details extends StatefulWidget {
  final MarineSpecie specie;

  const Details({
    super.key,
    required this.specie,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final UserPreferences _prefs = UserPreferences();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.specie.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      print(widget.specie.isFavorite);
      _isFavorite = !_isFavorite;
      widget.specie.isFavorite = _isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Agregado a favoritos' : 'Eliminado de favoritos'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.color2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _prefs,
      builder: (context, child) {
        final isDark = _prefs.isDarkMode;
        final bgColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
        final textColor = AppColors.textColor(isDark);
        final subTextColor = AppColors.subTextColor(isDark);

        return Scaffold(
          backgroundColor: bgColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400.0,
                floating: false,
                pinned: true,
                backgroundColor: bgColor,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.redAccent : Colors.white,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: widget.specie.imageUrl,
                        child: Image.network(
                          widget.specie.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network('https://picsum.photos/400/800', fit: BoxFit.cover),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              bgColor,
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.specie.commonName,
                        style: GoogleFonts.montserrat(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        widget.specie.scientificName,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: isDark ? AppColors.color4 : AppColors.lightAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          _buildInfoChip(Icons.category_outlined, widget.specie.order, isDark),
                          const SizedBox(width: 10),
                          _buildThreatChip(widget.specie.threatStatus, isDark),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildSectionTitle('Sobre esta especie', textColor),
                      const SizedBox(height: 12),
                      _buildGlassCard(
                        isDark: isDark,
                        child: Text(
                          widget.specie.description,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: textColor.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildSectionTitle('Detalles Técnicos', textColor),
                      const SizedBox(height: 12),
                      _buildGlassCard(
                        isDark: isDark,
                        child: Column(
                          children: [
                            _buildDetailRow(Icons.label_important_outline, 'Orden', widget.specie.order, isDark),
                            Divider(color: textColor.withOpacity(0.1)),
                            _buildDetailRow(Icons.security_outlined, 'Estado IUCN', widget.specie.threatStatus, isDark),
                            Divider(color: textColor.withOpacity(0.1)),
                            _buildDetailRow(Icons.biotech_outlined, 'Nombre Científico', widget.specie.scientificName, isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, required bool isDark}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardColor(isDark),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.textColor(isDark).withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, bool isDark) {
    final accent = isDark ? AppColors.color4 : AppColors.lightAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: AppColors.textColor(isDark),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreatChip(String status, bool isDark) {
    Color color;
    String label;
    switch (status) {
      case 'EXTINCT':
        color = Colors.black87;
        label = 'Extinto';
        break;
      case 'EXTINCT_IN_THE_WILD':
        color = Colors.deepPurpleAccent;
        label = 'Extinto en Estado Silvestre';
        break;
      case 'REGIONALLY_EXTINCT':
        color = Colors.indigo;
        label = 'Extinto Regionalmente';
        break;
      case 'CRITICAL':
      case 'CRITICALLY_ENDANGERED':
        color = Colors.redAccent;
        label = 'En Peligro Crítico';
        break;
      case 'ENDANGERED':
        color = Colors.orangeAccent;
        label = 'En Peligro';
        break;
      case 'VULNERABLE':
        color = Colors.amber;
        label = 'Vulnerable';
        break;
      case 'NEAR_THREATENED':
        color = Colors.lightGreen;
        label = 'Casi Amenazado';
        break;
      case 'LEAST_CONCERN':
        color = Colors.greenAccent;
        label = 'Preocupación Menor';
        break;
      case 'DATA_DEFICIENT':
        color = Colors.blueGrey;
        label = 'Datos Insuficientes';
        break;
      case 'NOT_APPLICABLE':
        color = Colors.grey;
        label = 'No Aplicable';
        break;
      case 'NOT_EVALUATED':
        color = Colors.blueAccent;
        label = 'No Evaluado';
        break;
      default:
        color = Colors.blueAccent;
        label = status.replaceAll('_', ' ');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isDark ? AppColors.color4 : AppColors.lightAccent),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: AppColors.subTextColor(isDark),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.montserrat(
                color: AppColors.textColor(isDark),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
