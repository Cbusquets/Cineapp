import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_trending.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetTrending getTrending;

  MovieBloc({required this.getTrending}) : super(MovieInitial()) {
    on<GetTrendingEvent>(_onGetTrending);
  }

  Future<void> _onGetTrending(
    GetTrendingEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    try {
      final movies = await getTrending();
      emit(MovieLoaded(movies));
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }
}