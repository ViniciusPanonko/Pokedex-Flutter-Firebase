import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'favoritos';

  Future<void> addFavorite(Pokemon pokemon) async {
    await _firestore.collection(_collection).doc(pokemon.id.toString()).set(pokemon.toMap());
  }

  Future<void> removeFavorite(int id) async {
    await _firestore.collection(_collection).doc(id.toString()).delete();
  }

  Stream<List<Pokemon>> getFavorites() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Pokemon.fromMap(doc.data())).toList();
    });
  }

  Future<bool> isFavorite(int id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id.toString()).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
