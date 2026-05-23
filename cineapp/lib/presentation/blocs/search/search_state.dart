import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class SearchState extends Equatable {
  final Map<int, String> genres;
  const SearchState({this.genres = const {}});

  @override
  List<Object?> get props => [genres];
}

class SearchInitial extends SearchState {
  const SearchInitial({super.genres});
}

class SearchLoading extends SearchState {
  const SearchLoading({super.genres});
}

class SearchLoaded extends SearchState {
  final List<Movie> movies;
  final int? selectedGenreId;

  const SearchLoaded(this.movies, {super.genres, this.selectedGenreId});

  @override
  List<Object?> get props => [movies, genres, selectedGenreId];
}

class SearchEmpty extends SearchState {
  final int? selectedGenreId;
  const SearchEmpty({super.genres, this.selectedGenreId});

  @override
  List<Object?> get props => [genres, selectedGenreId];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message, {super.genres});

  @override
  List<Object?> get props => [message, genres];
}