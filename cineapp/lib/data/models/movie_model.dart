import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
class MovieModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final String backdropPath;

  @HiveField(5)
  final double voteAverage;

  @HiveField(6)
  final String releaseDate;

  @HiveField(7)
  final List<int> genreIds;

  MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json['id'],
        title: json['title'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'] ?? '',
        backdropPath: json['backdrop_path'] ?? '',
        voteAverage: (json['vote_average'] ?? 0).toDouble(),
        releaseDate: json['release_date'] ?? '',
        genreIds: List<int>.from(json['genre_ids'] ?? []),
      );

  Movie toEntity() => Movie(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        releaseDate: releaseDate,
        genreIds: genreIds,
      );

  factory MovieModel.fromEntity(Movie movie) => MovieModel(
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        posterPath: movie.posterPath,
        backdropPath: movie.backdropPath,
        voteAverage: movie.voteAverage,
        releaseDate: movie.releaseDate,
        genreIds: movie.genreIds,
      );
}