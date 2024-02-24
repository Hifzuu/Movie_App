class Trailer {
  final String name;
  final String key;
  final String site;
  final String type;

  Trailer({
    required this.name,
    required this.key,
    required this.site,
    required this.type,
  });

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      name: json['name'],
      key: json['key'],
      site: json['site'],
      type: json['type'],
    );
  }
}
