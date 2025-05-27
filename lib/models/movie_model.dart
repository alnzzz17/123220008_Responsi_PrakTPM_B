class Movie {
  final String id;
  final String title;
  final String releaseDate;
  final String imageUrl;
  final List<String> genre;
  final DateTime? createdAt;
  final String? description;
  final String director;
  final List<String> cast;
  final String language;
  final String duration;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.imageUrl,
    required this.genre,
    this.createdAt,
    this.description,
    required this.director,
    required this.cast,
    required this.language,
    required this.duration,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '0',
      title: json['title'] ?? "Unknown",
      releaseDate: json['release_date'] ?? "Unknown",
      imageUrl: json['imgUrl'] ?? "",
      genre: (json['genre'] is List) 
          ? List<String>.from(json['genre']) 
          : ["Unknown"],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      description: json['description'] ?? "No description available",
      director: json['director'] ?? "Unknown",
      cast: (json['cast'] is List) 
          ? List<String>.from(json['cast']) 
          : ["Unknown"],
      language: json['language'] ?? "Unknown",
      duration: json['duration'] ?? "Unknown",
      rating: json['rating'] != null 
          ? double.tryParse(json['rating'].toString()) ?? 0.0 
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'release_date': releaseDate,
      'imgUrl': imageUrl,
      'genre': genre,
      'created_at': createdAt?.toIso8601String(),
      'description': description,
      'director': director,
      'cast': cast,
      'language': language,
      'duration': duration,
      'rating': rating,
    };
  }
}