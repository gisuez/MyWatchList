import 'package:flutter/material.dart';

class SeriesDetail {
  final bool adult;
  final String? backdropPath;
  final List<CreatedBy> createdBy;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final LastEpisodeToAir? lastEpisodeToAir;
  final String name;
  final List<Network> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<Season> seasons;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  SeriesDetail({
    required this.adult,
    this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    this.lastEpisodeToAir,
    required this.name,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  factory SeriesDetail.fromJson(Map<String, dynamic> json) {
    return SeriesDetail(
      adult: json['adult'] ?? true,
      backdropPath: json['backdrop_path'],
      createdBy:
          (json['created_by'] as List?)
              ?.map((x) => CreatedBy.fromJson(x))
              .toList() ??
          [],
      episodeRunTime: List<int>.from(json['episode_run_time'] ?? []),
      firstAirDate: json['first_air_date'] ?? '',
      genres:
          (json['genres'] as List?)?.map((x) => Genre.fromJson(x)).toList() ??
          [],
      homepage: json['homepage'] ?? '',
      id: json['id'] ?? 0,
      inProduction: json['in_production'] ?? true,
      languages: List<String>.from(json['languages'] ?? []),
      lastAirDate: json['last_air_date'] ?? '',
      lastEpisodeToAir: json['last_episode_to_air'] != null
          ? LastEpisodeToAir.fromJson(json['last_episode_to_air'])
          : null,
      name: json['name'] ?? '',
      networks:
          (json['networks'] as List?)
              ?.map((x) => Network.fromJson(x))
              .toList() ??
          [],
      numberOfEpisodes: json['number_of_episodes'] ?? 0,
      numberOfSeasons: json['number_of_seasons'] ?? 0,
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'],
      seasons:
          (json['seasons'] as List?)?.map((x) => Season.fromJson(x)).toList() ??
          [],
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      type: json['type'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "created_by": createdBy,
    "episode_run_time": episodeRunTime,
    "first_air_date": firstAirDate,
    "genres": genres,
    "homepage": homepage,
    "id": id,
    "in_production": inProduction,
    "languages": languages,
    "last_air_date": lastAirDate,
    "last_episode_to_air": lastEpisodeToAir,
    "name": name,
    "networks": networks,
    "number_of_episodes": numberOfEpisodes,
    "number_of_seasons": numberOfSeasons,
    "origin_country": originCountry,
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "seasons": seasons,
    "status": status,
    "tagline": tagline,
    "type": type,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  String get fullPosterPath => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : 'https://via.placeholder.com/500x750?text=No+Image';

  String get fullBackdropPath => backdropPath != null
      ? 'https://image.tmdb.org/t/p/original$backdropPath'
      : 'https://via.placeholder.com/1920x1080?text=No+Image';

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

// --- SOTTOCLASSI DI SUPPORTO ---

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class CreatedBy {
  final int id;
  final String creditId;
  final String name;
  final String? profilePath;

  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    this.profilePath,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['id'] ?? 0,
      creditId: json['credit_id'] ?? '',
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
    );
  }
}

class Network {
  final int id;
  final String name;
  final String? logoPath;

  Network({required this.id, required this.name, this.logoPath});

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoPath: json['logo_path'],
    );
  }
}

class Season {
  final String airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      airDate: json['air_date'] ?? '',
      episodeCount: json['episode_count'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      seasonNumber: json['season_number'] ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class LastEpisodeToAir {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final int seasonNumber;

  LastEpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.seasonNumber,
  });

  factory LastEpisodeToAir.fromJson(Map<String, dynamic> json) {
    return LastEpisodeToAir(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      airDate: json['air_date'] ?? '',
      episodeNumber: json['episode_number'] ?? 0,
      seasonNumber: json['season_number'] ?? 0,
    );
  }
}
