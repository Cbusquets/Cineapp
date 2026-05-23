import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final Movie movie;
  final bool isFavorite;
  ToggleFavoriteEvent(this.movie, this.isFavorite);

  @override
  List<Object?> get props => [movie, isFavorite];
}