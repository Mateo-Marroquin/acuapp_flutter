import '../api/marine_specie.dart';

class SpeciesRepository {
  static final SpeciesRepository _instance = SpeciesRepository._internal();

  factory SpeciesRepository() {
    return _instance;
  }

  SpeciesRepository._internal();

  final Map<String, List<MarineSpecie>> _allSpecies = {};

  void updateCategory(String categoryName, List<MarineSpecie> newSpecies) {
    _allSpecies[categoryName] = newSpecies;
  }

  List<MarineSpecie> getSpeciesByCategory(String categoryName) {
    return _allSpecies[categoryName] ?? [];
  }

  List<MarineSpecie> getAllFavorites() {
    List<MarineSpecie> favorites = [];
    _allSpecies.forEach((key, list) {
      favorites.addAll(list.where((specie) => specie.isFavorite));
    });
    final ids = favorites.map((e) => e.scientificName).toSet();
    favorites.retainWhere((x) => ids.remove(x.scientificName));
    return favorites;
  }
}