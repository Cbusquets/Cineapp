import 'package:flutter_test/flutter_test.dart';
import 'package:cineapp/domain/entities/movie.dart';
import 'package:cineapp/domain/usecases/get_trending.dart';
import 'package:cineapp/domain/usecases/search_movies.dart';
import 'package:cineapp/domain/usecases/toggle_favorite.dart';
import 'package:cineapp/domain/usecases/get_favorites.dart';
import 'package:cineapp/domain/repositories/movie_repository.dart';

class MockMovieRepository implements MovieRepository {
  final List<Movie> _favorites = [];

  final List<Movie> mockMovies = [
    Movie(
      id: 1,
      title: 'Interstellar',
      overview: 'Un viaje espacial épico',
      posterPath: '/poster1.jpg',
      backdropPath: '/backdrop1.jpg',
      voteAverage: 8.6,
      releaseDate: '2014-11-07',
      genreIds: [878, 18],
    ),
    Movie(
      id: 2,
      title: 'The Dark Knight',
      overview: 'Batman vs Joker',
      posterPath: '/poster2.jpg',
      backdropPath: '/backdrop2.jpg',
      voteAverage: 9.0,
      releaseDate: '2008-07-18',
      genreIds: [28, 80],
    ),
  ];

  @override
  Future<List<Movie>> getTrending() async => mockMovies;

  @override
  Future<List<Movie>> searchMovies(String query, {int? genreId}) async =>
      mockMovies.where((m) => m.title.toLowerCase().contains(query.toLowerCase())).toList();

  @override
  Future<List<Movie>> discoverByGenre(int genreId) async =>
      mockMovies.where((m) => m.genreIds.contains(genreId)).toList();

  @override
  Future<Movie> getMovieDetail(int movieId) async =>
      mockMovies.firstWhere((m) => m.id == movieId);

  @override
  Future<List<Movie>> getFavorites() async => List.from(_favorites);

  @override
  Future<void> saveFavorite(Movie movie) async => _favorites.add(movie);

  @override
  Future<void> removeFavorite(int movieId) async =>
      _favorites.removeWhere((m) => m.id == movieId);

  @override
  Future<bool> isFavorite(int movieId) async =>
      _favorites.any((m) => m.id == movieId);

  @override
  Future<Map<int, String>> getGenres() async => {28: 'Acción', 878: 'Ciencia ficción'};

  @override
  Future<String?> getTrailerUrl(int movieId) async =>
      'https://www.youtube.com/watch?v=example';
}

void main() {
  late MockMovieRepository repository;

  setUp(() {
    repository = MockMovieRepository();
  });

  group('GetTrending', () {
    test('debe retornar lista de películas en tendencia', () async {
      final usecase = GetTrending(repository);
      final result = await usecase();
      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result.first.title, 'Interstellar');
    });
  });

  group('SearchMovies', () {
    test('debe encontrar películas por título', () async {
      final usecase = SearchMovies(repository);
      final result = await usecase('dark');
      expect(result, isNotEmpty);
      expect(result.first.title, 'The Dark Knight');
    });

    test('debe retornar lista vacía si no hay coincidencias', () async {
      final usecase = SearchMovies(repository);
      final result = await usecase('xyzxyzxyz');
      expect(result, isEmpty);
    });
  });

  group('Favoritos', () {
    test('debe agregar una película a favoritos', () async {
      final toggle = ToggleFavorite(repository);
      final getFavorites = GetFavorites(repository);

      final movie = repository.mockMovies.first;
      await toggle(movie, false);

      final favorites = await getFavorites();
      expect(favorites, isNotEmpty);
      expect(favorites.first.id, movie.id);
    });

    test('debe quitar una película de favoritos', () async {
      final toggle = ToggleFavorite(repository);
      final getFavorites = GetFavorites(repository);

      final movie = repository.mockMovies.first;
      await toggle(movie, false);
      await toggle(movie, true);

      final favorites = await getFavorites();
      expect(favorites, isEmpty);
    });

    test('isFavorite debe retornar true si la película está guardada', () async {
      final movie = repository.mockMovies.first;
      await repository.saveFavorite(movie);
      final result = await repository.isFavorite(movie.id);
      expect(result, true);
    });

    test('isFavorite debe retornar false si la película no está guardada', () async {
      final result = await repository.isFavorite(999);
      expect(result, false);
    });
  });

  group('Movie entity', () {
    test('debe crear una entidad Movie correctamente', () {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test overview',
        posterPath: '/test.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 7.5,
        releaseDate: '2024-01-01',
        genreIds: [28],
      );

      expect(movie.id, 1);
      expect(movie.title, 'Test Movie');
      expect(movie.voteAverage, 7.5);
    });
  });
}