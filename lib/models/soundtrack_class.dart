class Soundtrack{
  final String title;
  final String anime;
  final String link;
  final String type;
  final String artist;
  final String support;

  const Soundtrack({
    required this.title,
    required this.anime,
    required this.link,
    required this.type,
    required this.artist,
    required this.support
  });

  factory Soundtrack.fromJson(Map<String, dynamic> json){
    return Soundtrack(
      title: json['title'] as String,
      anime: json['anime'] as String,
      link: json['link'] as String,
      type: json['type'] as String,
      artist: json['artist'] as String,
      support: json['support'] as String,
    );
  }
}