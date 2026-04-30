import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Projeto'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pokédex Flutter Firebase',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Objetivo: Desenvolver uma aplicação consumindo API externa (PokéAPI) e salvando dados no Firebase Firestore.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('APIs e Serviços:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('- PokéAPI'),
            Text('- Firebase Cloud Firestore'),
            SizedBox(height: 32),
            Text('Autor:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Vinícius Pannuco Ribeiro'),
          ],
        ),
      ),
    );
  }
}
