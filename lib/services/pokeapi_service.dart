import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&offset=$offset'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      
      final Iterable<Future<Pokemon?>> fetchTasks = results.map((result) async {
        try {
          final detailResponse = await http.get(Uri.parse(result['url']));
          if (detailResponse.statusCode == 200) {
            final detailData = json.decode(detailResponse.body);
            return Pokemon.fromJson(detailData);
          }
        } catch (_) {}
        return null;
      });
      
      final List<Pokemon?> fetchedPokemons = await Future.wait(fetchTasks);
      return fetchedPokemons.whereType<Pokemon>().toList();
    } else {
      throw Exception('Erro ao carregar lista de Pokémon');
    }
  }

  Future<Pokemon> fetchPokemonDetail(String nameOrId) async {
    final response = await http.get(Uri.parse('$baseUrl/$nameOrId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson(data);
    } else {
      throw Exception('Erro ao carregar detalhes do Pokémon');
    }
  }

  Future<List<String>> fetchPokemonByType(String type) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/type/$type'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List pokemonList = data['pokemon'];
      return pokemonList.map<String>((p) => p['pokemon']['url'] as String).toList();
    } else {
      throw Exception('Erro ao carregar tipo');
    }
  }

  Future<List<Pokemon>> fetchPokemonDetailsFromUrls(List<String> urls) async {
    final Iterable<Future<Pokemon?>> fetchTasks = urls.map((url) async {
      try {
        final detailResponse = await http.get(Uri.parse(url));
        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);
          return Pokemon.fromJson(detailData);
        }
      } catch (_) {}
      return null;
    });

    final List<Pokemon?> fetchedPokemons = await Future.wait(fetchTasks);
    return fetchedPokemons.whereType<Pokemon>().toList();
  }
}
