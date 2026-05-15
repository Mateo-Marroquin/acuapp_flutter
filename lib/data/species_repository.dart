import '../api/marine_specie.dart';

class SpeciesRepository {
  static final SpeciesRepository _instance = SpeciesRepository._internal();

  factory SpeciesRepository() {
    return _instance;
  }

  SpeciesRepository._internal();

  final Map<String, List<MarineSpecie>> _allSpecies = {};

  void updateCategory(String categoryName, List<MarineSpecie> newSpecies) {
    final syncedList = newSpecies.map((s) => syncSpecie(s)).toList();
    _allSpecies[categoryName] = syncedList;
  }

  List<MarineSpecie> getSpeciesByCategory(String categoryName) {
    return _allSpecies[categoryName] ?? [];
  }

  void addSpecies(MarineSpecie specie) {
    for (var list in _allSpecies.values) {
      if (list.any((s) => s.scientificName == specie.scientificName)) {
        return;
      }
    }
    
    if (!_allSpecies.containsKey('Search')) {
      _allSpecies['Search'] = [];
    }
    _allSpecies['Search']!.add(specie);
  }

  MarineSpecie syncSpecie(MarineSpecie specie) {
    for (var list in _allSpecies.values) {
      for (var s in list) {
        if (s.scientificName == specie.scientificName) {
          return s;
        }
      }
    }
    addSpecies(specie);
    return specie;
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

  List<MarineSpecie> getRandomSpecies(int count) {
    List<MarineSpecie> all = [];
    _allSpecies.forEach((key, list) {
      all.addAll(list);
    });
    
    if (all.isEmpty) return [];
    
    all.shuffle();
    return all.take(count).toList();
  }
}