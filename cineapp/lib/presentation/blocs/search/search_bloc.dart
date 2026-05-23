import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/repositories/movie_repository.dart';
import '../../../domain/usecases/search_movies.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  final MovieRepository repository;

  Map<int, String> _genres = {};
  int? _selectedGenreId;
  String _lastQuery = '';

  SearchBloc({required this.searchMovies, required this.repository})
      : super(const SearchInitial()) {
    on<LoadGenresEvent>(_onLoadGenres);
    on<SearchMoviesEvent>(_onSearch);
    on<ClearSearchEvent>(_onClear);
  }

  Future<void> _onLoadGenres(
    LoadGenresEvent event,
    Emitter<SearchState> emit,
  ) async {
    _genres = await repository.getGenres();
    emit(SearchInitial(genres: _genres));
  }

  Future<void> _onSearch(
    SearchMoviesEvent event,
    Emitter<SearchState> emit,
  ) async {
    _lastQuery = event.query;
    _selectedGenreId = event.genreId;

    emit(SearchLoading(genres: _genres));
    try {
      List<Movie> movies = [];

      if (event.query.isEmpty && event.genreId != null) {
        movies = await repository.discoverByGenre(event.genreId!);
      } else if (event.query.isNotEmpty) {
        movies = await repository.searchMovies(
          event.query,
          genreId: event.genreId,
        );
      } else {
        emit(SearchInitial(genres: _genres));
        return;
      }

      if (movies.isEmpty) {
        emit(SearchEmpty(genres: _genres, selectedGenreId: _selectedGenreId));
      } else {
        emit(SearchLoaded(movies, genres: _genres, selectedGenreId: _selectedGenreId));
      }
    } catch (e) {
      emit(SearchError(e.toString(), genres: _genres));
    }
  }

  void _onClear(ClearSearchEvent event, Emitter<SearchState> emit) {
    _selectedGenreId = null;
    _lastQuery = '';
    emit(SearchInitial(genres: _genres));
  }
}