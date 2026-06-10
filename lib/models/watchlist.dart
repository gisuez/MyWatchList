class Watchlist {
  final int? id;
  final int userId;
  final int tmdbId;
  final String title;
  final String releaseDate;
  final double tmdbRating;
  // parametri dell'utente
  final String status;
  final int? userRating;
  final String? notes;

  Watchlist({
    required this.id,
    required this.userId,
    required this.tmdbId,
    required this.title,
    required this.releaseDate,
    required this.tmdbRating,
    required this.status,
    this.userRating,
    this.notes,
  });

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'],
      userId: json['user_id'],
      tmdbId: json['tmdb_id'],
      title: json['title'],
      releaseDate: json['release_date'],
      tmdbRating: json['tmdb_rating'],
      status: json['status'],
      userRating: json['user_rating'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'user_id': userId,
    'tmdb_id': tmdbId,
    'title': title,
    'release_date': releaseDate,
    'tmdb_rating': tmdbRating,
    'status': status,
    'user_rating': userRating,
    'notes': notes,
  };
}
