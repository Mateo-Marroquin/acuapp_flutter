import 'package:acuapp/api/marine_specie.dart';
import 'package:acuapp/category.dart';
import 'package:acuapp/details.dart';
import 'package:acuapp/services/api_service.dart';
import 'package:acuapp/widgets/marine_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:acuapp/services/firebase_service.dart';
import 'package:acuapp/data/species_repository.dart';
import 'constants/colors.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late FlutterEarthGlobeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/2k_stars.jpg').image,
      surface: Image.asset('assets/2k_earth-day.jpg').image,
    );

    _addOceanPoints();
  }

  void _addOceanPoints() {
    final oceans = [
      {'name': 'Pacífico', 'lat': -8.7, 'lng': -124.5},
      {'name': 'Atlántico', 'lat': 15.2, 'lng': -36.1},
      {'name': 'Índico', 'lat': -21.0, 'lng': 80.0},
      {'name': 'Ártico', 'lat': 85.0, 'lng': 0.0},
      {'name': 'Antártico', 'lat': -68.0, 'lng': 0.0},
    ];

    for (var ocean in oceans) {
      _controller.addPoint(
        Point(
          id: ocean['name'].toString(),
          coordinates: GlobeCoordinates(ocean['lat'] as double, ocean['lng'] as double),
          label: ocean['name'].toString(),
          isLabelVisible: true,
          style: PointStyle(color: Colors.cyanAccent.withOpacity(0.2), size: 20),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Océano ${ocean['name']} seleccionado')),
            );
          },
        ),
      );
    }
  }

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
                  'Explora',
                  style: GoogleFonts.montserrat(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      MarineCard(imageUrl: 'assets/clownFish.jpg', title: 'Peces', yOffset: -0.5,
                          onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Category(title: 'Peces',)),
                          );}
                      ),
                      MarineCard(imageUrl: 'assets/shark.jpg', title: 'Tiburones', yOffset: -0.8,
                          onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Category(title: 'Tiburones',)),
                          );}
                      ),
                      MarineCard(imageUrl: 'assets/turtle.jpg', title: 'Tortugas', yOffset: -0.3,
                          onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Category(title: 'Tortugas',)),
                          );}
                      ),
                      MarineCard(imageUrl: 'assets/octopus.jpg', title: 'Pulpos', yOffset: -0.0,
                          onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Category(title: 'Pulpos',)),
                          );}
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(),
                      ),
                    );
                  },
                  child: Text('Probar API en Consola'),
                ),
                ElevatedButton(
                  onPressed: () async {

                  },
                  child: Text('Probar Firebase'),
                ),
                Text(
                  'Océanos del Mundo',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Container(
                  height: 700,
                  width: double.infinity,
                  child: FlutterEarthGlobe(
                    alignment: const Alignment(0, 0),
                    controller: _controller,
                    radius: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}