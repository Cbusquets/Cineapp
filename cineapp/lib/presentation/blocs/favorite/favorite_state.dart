import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Movie> movies;
  FavoriteLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}