import 'package:flutter/material.dart';

class Series {
  final int id;
  final bool adult;
  final String? backdropPath;
  final List<dynamic> genreIds;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String firstAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;

  Series({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json["id"],
      adult: json["adult"],
      backdropPath: json["backdrop_path"],
      genreIds: json["genre_ids"],
      originalLanguage: json["original_language"],
      originalName: json["original_name"],
      overview: json["overview"],
      popularity: json["popularity"],
      posterPath: json["poster_path"],
      firstAirDate: json["first_air_date"],
      name: json["name"] ?? "Titolo non disponibile",
      voteAverage: json["vote_average"],
      voteCount: json["vote_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": genreIds,
    "id": id,
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "first_air_date": firstAirDate,
    "name": name,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  String get fullPosterPath {
    if (posterPath == null || posterPath!.isEmpty) {
      return "https://via.placeholder.com/500x750?text=No+Image";
    }
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropPath {
    if (backdropPath == null || backdropPath!.isEmpty) {
      return "https://via.placeholder.com/1280x720?text=No+Image";
    }
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  String get releaseYear {
    return firstAirDate.split('-')[0];
  }

  static Color genreColor(int genreId) {
    switch (genreId) {
      case 28:
        return const Color(0xFFE24B4A); // Azione       — rosso vivace
      case 12:
        return const Color(0xFFEF9F27); // Avventura    — ambra/oro
      case 16:
        return const Color(0xFF63B3ED); // Animazione   — azzurro cielo
      case 35:
        return const Color(0xFFF6D860); // Commedia     — giallo solare
      case 80:
        return const Color(0xFF888780); // Crime        — grigio freddo
      case 99:
        return const Color(0xFF639922); // Documentario — verde naturale
      case 18:
        return const Color(0xFF7F77DD); // Dramma       — viola profondo
      case 10751:
        return const Color(0xFFF4C0D1); // Famiglia     — rosa tenue
      case 14:
        return const Color(0xFF1D9E75); // Fantasy      — smeraldo
      case 36:
        return const Color(0xFFB4B2A9); // Storia       — grigio antico
      case 27:
        return const Color(0xFF5F1313); // Horror       — rosso sangue
      case 10402:
        return const Color(0xFFD4537E); // Musica       — fucsia
      case 9648:
        return const Color(0xFF534AB7); // Mistero      — indaco
      case 10749:
        return const Color(0xFFED93B1); // Romance      — rosa
      case 878:
        return const Color(0xFF378ADD); // Fantascienza — blu elettrico
      case 10770:
        return const Color(0xFF5DCAA5); // Film TV      — teal
      case 53:
        return const Color(0xFFF09995); // Thriller     — corallo teso
      case 10752:
        return const Color(0xFF6B4C2A); // Guerra       — terra bruciata
      case 37:
        return const Color(0xFFD85A30); // Western      — arancio polvere
      default:
        return const Color(0xFF888780); // Fallback     — grigio
    }
  }
}

class GenreMapper {
  static const Map<int, String> _genres = {
    28: "Azione",
    12: "Avventura",
    16: "Animazione",
    35: "Commedia",
    80: "Crime",
    99: "Documentario",
    18: "Dramma",
    10751: "Famiglia",
    14: "Fantasy",
    36: "Storia",
    27: "Horror",
    10402: "Musica",
    9648: "Mistero",
    10749: "Romance",
    878: "Fantascienza",
    10770: "Film TV",
    53: "Thriller",
    10752: "Guerra",
    37: "Western",
  };

  static String getGenreName(int id) {
    return _genres[id] ?? "Sconosciuto";
  }
}
