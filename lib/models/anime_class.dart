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
      name: json['name'] as String, 
      altName: json['altName'] as String?, 
      year: json['year'] as int, 
      season: json['season'] as String, 
      theme: List<String>.from(json['theme']), 
      genre: List<String>.from(json['genre']), 
      demographic: json['demographic'] as String, 
      studio: List<String>.from(json['studio']), 
      source: json['source'] as String, 
      status: json['status'] as String, 
      format: List<String>.from(json['format']),
      synopsis: json['synopsis'] as String,
    );
  }
}