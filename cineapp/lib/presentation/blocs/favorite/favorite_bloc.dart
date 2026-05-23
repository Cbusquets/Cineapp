import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorites.dart';
import '../../../domain/usecases/toggle_favorite.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavorites getFavorites;
  final ToggleFavorite toggleFavorite;

  FavoriteBloc({
    required this.getFavorites,
    required this.toggleFavorite,
  }) : super(FavoriteInitial()) {
    on<GetFavoritesEvent>(_onGetFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onGetFavorites(
    GetFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final movies = await getFavorites();
      emit(FavoriteLoaded(movies));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await toggleFavorite(event.movie, event.isFavorite);
      add(GetFavoritesEvent());
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}