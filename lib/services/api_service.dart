import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:acuapp/api/marine_specie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String _baseUrlGBIF = 'https://api.gbif.org/v1/species';

  Future<List<MarineSpecie>> fetchRandomMarineSpecies(int taxonKey, String categoryName, int count) async {
    int offset = await getOffset(taxonKey);

    final urlGBIF = Uri.parse(
        '$_baseUrlGBIF/search?highertaxonKey=$taxonKey&rank=SPECIES&status=ACCEPTED&limit=$count&offset=$offset');

    print(urlGBIF);
    try {
      final responseGBIF = await http.get(urlGBIF);

      if (responseGBIF.statusCode == 200) {
        final data = jsonDecode(responseGBIF.body);
        List<MarineSpecie> results = [];

        for (var item in data['results']) {

          Map<String, String> wikiData = await fetchWikipedia(item['canonicalName']);

          String cName = 'No hay nombre común';
          if (item['vernacularNames'] != null &&
              item['vernacularNames'] is List &&
              item['vernacularNames'].isNotEmpty) {

            final List vNames = item['vernacularNames'];

            var spaName = vNames.firstWhere(
                    (v) => v['language'] == 'spa',
                orElse: () => null
            );

            var engName = vNames.firstWhere(
                    (v) => v['language'] == 'eng',
                orElse: () => null
            );

            if (spaName != null) {
              cName = spaName['vernacularName'];
            } else if (engName != null) {
              cName = engName['vernacularName'];
            } else {
              cName = 'No hay nombre cientifico';
            }

          }

          String status = '';
          if (item['threatStatuses'] != null &&
              item['threatStatuses'] is List &&
              item['threatStatuses'].isNotEmpty) {
            status = item['threatStatuses'][0].toString();
          }

          results.add(
              MarineSpecie(
                  scientificName: item['canonicalName'] ?? 'Nombre no encontrado',
                  commonName: cName,
                  order: item['order'] ?? item['family'] ??'Orden no encontrada',
                  threatStatus: status != '' ? status : 'DATA_DEFICIENT', //TODO: Agregar mapeo a español
                  description: wikiData['description'],
                  imageUrl: wikiData['imageUrl']
              )
          );
        }
        return results;
      }
      else{
        throw Exception('Error en API GBIF: ${responseGBIF.statusCode}');
      }
    }
    catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<Map<String, String>> fetchWikipedia(String name) async {
    final String cleanName = name.trim().replaceAll(' ', '_');

    final Map<String, String> headers = {
      'User-Agent': 'AcuaApp/1.0 (${dotenv.env['EMAIL']}; Facultad de Ingenieria UASLP)',
      'Accept': 'application/json',
    };

    try {
      final urlEsp = Uri.parse('https://es.wikipedia.org/api/rest_v1/page/summary/$cleanName');
      final responseEsp = await http.get(urlEsp, headers: headers);

      if (responseEsp.statusCode == 200) {
        return _processWikiResponse(responseEsp.body);
      }

      if (responseEsp.statusCode == 404 || responseEsp.statusCode == 429) {
        final urlEng = Uri.parse('https://en.wikipedia.org/api/rest_v1/page/summary/$cleanName');
        final responseEng = await http.get(urlEng, headers: headers);

        if (responseEng.statusCode == 200) {
          return _processWikiResponse(responseEng.body);
        }
      }

      throw Exception('No se encontró información en ningún idioma');

    } catch (e) {
      print('Error en Wiki: $e');
      return {
        'description': 'Información no disponible por el momento.',
        'imageUrl': 'https://picsum.photos/200'
      };
    }
  }

  Map<String, String> _processWikiResponse(String body) {
    final data = jsonDecode(body);
    return {
      'description': data['extract'] ?? 'Sin descripción.',
      'imageUrl': data['thumbnail']?['source'] ?? 'https://picsum.photos/200',
    };
  }

  Future<int> getOffset(int taxonKey) async {
    final url = 'https://api.gbif.org/v1/species/search?highertaxonKey=$taxonKey&rank=SPECIES&status=ACCEPTED';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int count = data['count'] ?? 0;

        if(count < 10) return count;

        int randomOffset = Random().nextInt(count);
        return randomOffset;
      }
      return 0;
    }catch(e) {
      print('Error: $e');
      return 0;
      }
    }

  Future<void> testFetch() async {
    print('Prueba de API:');

    final results = await fetchRandomMarineSpecies(11418114, 'Tiburones', 10);

    if (results.isEmpty) {
      print('No se obtuvieron resultados.');
    } else {
      print('Se encontraron ${results.length} especies:');
      for (var specie in results) {
        print('-----------------------------------');
        print('Científico: ${specie.scientificName}');
        print('Común: ${specie.commonName}');
        print('Orden: ${specie.order}');
        print('Estado: ${specie.threatStatus}');
        print('Descripción: ${specie.description}');
        print('Imagen: ${specie.imageUrl}');
        print('-----------------------------------');
      }
    }
  }

}