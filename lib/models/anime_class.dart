class Anime {
  final String name;
  final String? altName;
  final int year;
  final String season;
  final List<String> theme;
  final List<String> genre;
  final String demographic;
  final List<String> studio;
  final String source;
  final String status;
  final List<String> format;
  final String synopsis;

  const Anime({
    required this.name,
    this.altName,
    required this.year,
    required this.season,
    required this.theme,
    required this.genre,
    required this.demographic,
    required this.studio,
    required this.source,
    required this.status,
    required this.format,
    required this.synopsis
  });

  factory Anime.fromJson(Map<String, dynamic> json){
    return Anime(
      name: json['name'] as String, //1
      altName: json['altName'] as String?, 
      year: json['year'] as int, //2
      season: json['season'] as String, //3
      theme: List<String>.from(json['theme']), //4
      genre: List<String>.from(json['genre']), //5
      demographic: json['demographic'] as String, //6
      studio: List<String>.from(json['studio']), //7
      source: json['source'] as String, //8
      status: json['status'] as String, //9
      format: List<String>.from(json['format']),
      synopsis: json['synopsis'] as String,
    );
  }
}