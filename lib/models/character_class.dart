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
      name: json['name'] as String, //1
      series: json['series'] as String, //2
      eye: List<String>.from(json['eye']), //3
      hair: List<String>.from(json['hair']), //4
      sex:  json['sex'] as String, //5
      species: json['species'] as String, //6
      occupation: List<String>.from(json['occupation']), //7
      affiliation: List<String>.from(json['affiliation']), //8
      status: json['status'] as String, //9
      power: List<String>.from(json['power']), //10
      signature: json['signature'] as String, 
      quote: json['quote'] as String,
    );
  }
}