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

  String toString() {
    // Convert the Trailer object to a string representation
    return '$name,$key,$site,$type';
  }

  factory Trailer.fromString(String string) {
    // Check if the string contains the expected separator
    if (!string.contains(',')) {
      throw FormatException('Invalid string format for Trailer');
    }

    // Create a Trailer object from a string representation
    List<String> parts = string.split(',');

    try {
      if (parts.length >= 4) {
        return Trailer(
          name: parts[0],
          key: parts[1],
          site: parts[2],
          type: parts[3],
        );
      } else {
        throw FormatException('Invalid string format for Trailer');
      }
    } catch (e) {
      // Handle the exception, print or log the problematic string
      print('Error creating Trailer from string: $string\nError: $e');

      // You can return a default Trailer or rethrow the exception based on your use case
      // return Trailer(name: '', key: '', site: '', type: '');
      rethrow;
    }
  }
}
