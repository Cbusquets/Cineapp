import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_movies.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  SearchBloc({required this.searchMovies}) : super(SearchInitial()) {
    on<SearchMoviesEvent>(_onSearch);
    on<ClearSearchEvent>(_onClear);
  }

  Future<void> _onSearch(
    SearchMoviesEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final movies = await searchMovies(event.query);
      if (movies.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(movies));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClear(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}