import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:acuapp/constants/colors.dart';
import 'package:acuapp/api/marine_specie.dart';
import 'package:acuapp/widgets/specie_card.dart';
import 'package:acuapp/details.dart';
import 'package:acuapp/data/species_repository.dart';
import 'dart:ui';
import 'package:acuapp/services/auth_service.dart';
import 'package:acuapp/settings.dart';
import 'package:acuapp/data/user_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserPreferences _prefs = UserPreferences();
  final SpeciesRepository _repository = SpeciesRepository();
  List<MarineSpecie> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favorites = _repository.getAllFavorites();
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildProfileHeader(isDarkMode),
                          const SizedBox(height: 40),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Mis Especies Favoritas',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor(isDarkMode),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  if (_favorites.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 80,
                              color: AppColors.textColor(isDarkMode).withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aún no tienes favoritos',
                              style: GoogleFonts.montserrat(
                                color: AppColors.subTextColor(isDarkMode),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final specie = _favorites[index];
                          return SpecieCard(
                            imageUrl: specie.imageUrl,
                            title: specie.commonName,
                            subtitle: specie.scientificName,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Details(specie: specie),
                                ),
                              );
                              _loadFavorites();
                            },
                          );
                        },
                        childCount: _favorites.length,
                      ),
                    ),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: AppColors.cardColor(isDarkMode),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.textColor(isDarkMode).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.settings, color: AppColors.subTextColor(isDarkMode)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Settings()),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.color4.withOpacity(0.3),
                    backgroundImage: AuthService().userPhotoUrl != null
                        ? NetworkImage(AuthService().userPhotoUrl!)
                        : null,
                    child: AuthService().userPhotoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: AppColors.textColor(isDarkMode),
                          )
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AuthService().userName ?? 'Nombre de Usuario',
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor(isDarkMode),
                    ),
                  ),
                  Text(
                    AuthService().userEmail ?? 'Correo',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColors.subTextColor(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Favoritos', _favorites.length.toString(), isDarkMode),
                      Container(
                        width: 1,
                        height: 30,
                        color: AppColors.textColor(isDarkMode).withOpacity(0.2),
                      ),
                      _buildStatColumn('Nivel', 'Principiante', isDarkMode),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, bool isDarkMode) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor(isDarkMode),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: AppColors.subTextColor(isDarkMode),
          ),
        ),
      ],
    );
  }
}
