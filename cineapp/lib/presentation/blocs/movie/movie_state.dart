import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  MovieLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);

  @override
  List<Object?> get props => [message];
}