import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/marine_specie.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CollectionReference _peces = FirebaseFirestore.instance.collection(
    'peces',
  );

  Future<void> saveSpecie(MarineSpecie specie) async {
    try {
      await _peces.add({
        'scientificName': specie.scientificName,
        'commonName': specie.commonName,
        'order': specie.order,
        'threatStatus': specie.threatStatus,
        'description': specie.description,
        'imageUrl': specie.imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error al guardar en Firebase: $e");
    }
  }

  Stream<List<MarineSpecie>> getPeces() {
    return _peces.orderBy('timestamp', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MarineSpecie(
          scientificName: data['scientificName'] ?? '',
          commonName: data['commonName'] ?? '',
          order: data['order'] ?? '',
          threatStatus: data['threatStatus'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> deletePez(String docId) async {
    await _peces.doc(docId).delete();
  }

}
