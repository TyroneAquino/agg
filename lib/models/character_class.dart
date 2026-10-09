class Character {
  final String name;
  final String series;
  final List<String> eye;
  final List<String> hair;
  final String sex;
  final String species;
  final List<String> occupation;
  final List<String> affiliation;
  final String status;
  final List<String> power;
  final String signature;
  final String quote;

  const Character({
    required this.name,
    required this.series,
    required this.eye,
    required this.hair,
    required this.sex,
    required this.species,
    required this.occupation,
    required this.affiliation,
    required this.status,
    required this.power,
    required this.signature,
    required this.quote,
  });

  factory Character.fromJson(Map<String, dynamic> json){
    return Character(
      name: json['name'] as String, 
      series: json['series'] as String, 
      eye: List<String>.from(json['eye']), 
      hair: List<String>.from(json['hair']), 
      sex:  json['sex'] as String, 
      species: json['species'] as String, 
      occupation: List<String>.from(json['occupation']), 
      affiliation: List<String>.from(json['affiliation']), 
      status: json['status'] as String, 
      power: List<String>.from(json['power']), 
      signature: json['signature'] as String, 
      quote: json['quote'] as String,
    );
  }
}