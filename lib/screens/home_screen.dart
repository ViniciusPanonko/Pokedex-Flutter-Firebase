import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';
import '../services/pokeapi_service.dart';
import '../widgets/pokemon_card.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokeApiService _apiService = PokeApiService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  List<Pokemon> _pokemonList = [];
  List<String> _currentTypeUrls = [];
  
  bool _isLoading = true;
  bool _isFetchingMore = false;
  bool _isSearching = false;
  
  int _offset = 0;
  final int _limit = 20;

  String _selectedType = 'all';

  final List<String> _pokemonTypes = [
    'all', 'normal', 'fighting', 'flying', 'poison', 'ground', 'rock', 'bug', 'ghost', 'steel',
    'fire', 'water', 'grass', 'electric', 'psychic', 'ice', 'dragon', 'dark', 'fairy'
  ];

  @override
  void initState() {
    super.initState();
    _loadPokemon();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore &&
        !_isLoading &&
        !_isSearching) {
      _loadMorePokemon();
    }
  }

  Future<void> _loadPokemon() async {
    setState(() {
      _isLoading = true;
      _offset = 0;
      _pokemonList.clear();
      _isSearching = false;
    });

    try {
      if (_selectedType == 'all') {
        final list = await _apiService.fetchPokemonList(limit: _limit, offset: _offset);
        setState(() {
          _pokemonList = list;
          _isLoading = false;
        });
      } else {
        _currentTypeUrls = await _apiService.fetchPokemonByType(_selectedType);
        final urlsToFetch = _currentTypeUrls.take(_limit).toList();
        final list = await _apiService.fetchPokemonDetailsFromUrls(urlsToFetch);
        setState(() {
          _pokemonList = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao buscar dados da API.')),
        );
      }
    }
  }

  Future<void> _loadMorePokemon() async {
    if (_selectedType != 'all' && _offset + _limit >= _currentTypeUrls.length) {
      return; 
    }
    
    setState(() {
      _isFetchingMore = true;
    });

    _offset += _limit;

    try {
      if (_selectedType == 'all') {
        final list = await _apiService.fetchPokemonList(limit: _limit, offset: _offset);
        setState(() {
          _pokemonList.addAll(list);
          _isFetchingMore = false;
        });
      } else {
        final urlsToFetch = _currentTypeUrls.skip(_offset).take(_limit).toList();
        final list = await _apiService.fetchPokemonDetailsFromUrls(urlsToFetch);
        setState(() {
          _pokemonList.addAll(list);
          _isFetchingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  Future<void> _searchPokemon(String query) async {
    if (query.trim().isEmpty) {
      _loadPokemon();
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoading = true;
      _selectedType = 'all'; 
    });

    try {
      final pokemon = await _apiService.fetchPokemonDetail(query.trim().toLowerCase());
      setState(() {
        _pokemonList = [pokemon];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _pokemonList = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar Pokémon',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadPokemon();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: _searchPokemon,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedType,
                        isExpanded: true,
                        icon: const Icon(Icons.filter_list),
                        items: _pokemonTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type.toUpperCase(), style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null && newValue != _selectedType) {
                            setState(() {
                              _selectedType = newValue;
                              _searchController.clear();
                              _isSearching = false;
                            });
                            _loadPokemon();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Carregando Pokémon...'),
                      ],
                    ),
                  )
                : _pokemonList.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum Pokémon encontrado.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _pokemonList.length,
                        itemBuilder: (context, index) {
                          final pokemon = _pokemonList[index];
                          return PokemonCard(
                            pokemon: pokemon,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(pokemon: pokemon),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
          if (_isFetchingMore)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
