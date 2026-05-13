import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/constants/colors.dart';

class Details extends StatefulWidget {
  final String scientificName;
  final String commonName;
  final String order;
  final String threatStatus;
  final String description;
  final String imageUrl;

  const Details({
    super.key,
    required this.scientificName,
    required this.commonName,
    required this.order,
    required this.threatStatus,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.color1,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.imageUrl,
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network('https://picsum.photos/400/800', fit: BoxFit.cover),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.color1,
                        ],
                        stops: [0.6, 1.0],
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
                    widget.commonName,
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.scientificName,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: AppColors.color4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      _buildInfoChip(Icons.category_outlined, widget.order),
                      const SizedBox(width: 10),
                      _buildThreatChip(widget.threatStatus),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle('Sobre esta especie'),
                  const SizedBox(height: 12),
                  _buildGlassCard(
                    child: Text(
                      widget.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.6,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  _buildSectionTitle('Detalles Técnicos'),
                  const SizedBox(height: 12),
                  _buildGlassCard(
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.label_important_outline, 'Orden', widget.order),
                        const Divider(color: Colors.white10),
                        _buildDetailRow(Icons.security_outlined, 'Estado IUCN', widget.threatStatus),
                        const Divider(color: Colors.white10),
                        _buildDetailRow(Icons.biotech_outlined, 'Nombre Científico', widget.scientificName),
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
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.color2.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.color3.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.color4),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreatChip(String status) {
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

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.color4),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.montserrat(
                color: Colors.white,
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
