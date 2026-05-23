import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchMoviesEvent extends SearchEvent {
  final String query;
  final int? genreId;
  SearchMoviesEvent(this.query, {this.genreId});

  @override
  List<Object?> get props => [query, genreId];
}

class ClearSearchEvent extends SearchEvent {}

class LoadGenresEvent extends SearchEvent {}