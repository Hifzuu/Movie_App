// Represents a trailer associated with a movie
class Trailer {
  final String name;
  final String key;
  final String site;
  final String type;

  // Constructor to create a Trailer instance
  Trailer({
    required this.name,
    required this.key,
    required this.site,
    required this.type,
  });

  // Factory method to create a Trailer instance from JSON data
  factory Trailer.fromJson(Map<String, dynamic> json) {
    // Create and return a Trailer instance
    return Trailer(
      name: json['name'],
      key: json['key'],
      site: json['site'],
      type: json['type'],
    );
  }

  String toString() {
    // Convert the Trailer object to a string
    return '$name|*|$key|*|$site|*|$type';
  }

  // Factory method to create a Trailer instance from a string
  factory Trailer.fromString(String string) {
    try {
      if (string.toLowerCase() == 'teaser') {
        // Skip processing for specific values like "Teaser"
        print('Skipped processing for value: $string');
        return Trailer(key: '', name: '', site: '', type: '');
      }

      // Split the input string into parts
      List<String> parts = string.split('|*|');

      // Check if the parts list has the expected number of components
      if (parts.length >= 4) {
        return Trailer(
          name: parts[0],
          key: parts[1],
          site: parts[2],
          type: parts[3],
        );
      } else {
        // Handle the case where the input string is not in the expected format
        print('Error: Invalid format for Trailer: $string');
        return Trailer(key: '', name: '', site: '', type: '');
      }
    } catch (e) {
      // Handle other potential errors during the process
      print('Error creating Trailer from string: $string\nError: $e');
      return Trailer(key: '', name: '', site: '', type: '');
    }
  }
}
