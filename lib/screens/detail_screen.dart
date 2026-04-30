import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';
import '../services/firebase_service.dart';

class DetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const DetailScreen({super.key, required this.pokemon});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    bool isFav = await _firebaseService.isFavorite(widget.pokemon.id);
    setState(() {
      _isFavorite = isFav;
    });
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await _firebaseService.removeFavorite(widget.pokemon.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.pokemon.name} removido dos favoritos!')),
        );
      }
    } else {
      await _firebaseService.addFavorite(widget.pokemon);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.pokemon.name} adicionado aos favoritos!')),
        );
      }
    }
    _checkFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name.toUpperCase()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.pokemon.image.isNotEmpty
                ? Image.network(widget.pokemon.image, height: 200, fit: BoxFit.contain)
                : const Icon(Icons.image_not_supported, size: 100),
            const SizedBox(height: 16),
            Text(
              '#${widget.pokemon.id} - ${widget.pokemon.name.toUpperCase()}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Altura: ${widget.pokemon.height / 10} m', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Peso: ${widget.pokemon.weight / 10} kg', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    const Text('Tipos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: widget.pokemon.types.map((t) => Chip(label: Text(t.toUpperCase()))).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Habilidades:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: widget.pokemon.abilities.map((a) => Chip(label: Text(a.toUpperCase()))).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        backgroundColor: _isFavorite ? Colors.red : Colors.grey,
        child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
      ),
    );
  }
}
