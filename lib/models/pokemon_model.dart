class Pokemon {
  final int id;
  final String name;
  final String image;
  final List<String> types;
  final int height;
  final int weight;
  final List<String> abilities;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> typesList = [];
    if (json['types'] != null) {
      for (var t in json['types']) {
        typesList.add(t['type']['name']);
      }
    }

    List<String> abilitiesList = [];
    if (json['abilities'] != null) {
      for (var a in json['abilities']) {
        abilitiesList.add(a['ability']['name']);
      }
    }


    int idValue = json['id'] ?? 0;
    

    String imageUrl = '';
    if (json['sprites'] != null && 
        json['sprites']['other'] != null && 
        json['sprites']['other']['official-artwork'] != null) {
      imageUrl = json['sprites']['other']['official-artwork']['front_default'] ?? '';
    } else {

      imageUrl = json['sprites']?['front_default'] ?? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$idValue.png';
    }

    return Pokemon(
      id: idValue,
      name: json['name'] ?? '',
      image: imageUrl,
      types: typesList,
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      abilities: abilitiesList,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'types': types,
      'height': height,
      'weight': weight,
      'abilities': abilities,
    };
  }

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      types: List<String>.from(map['types'] ?? []),
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
      abilities: List<String>.from(map['abilities'] ?? []),
    );
  }
}
