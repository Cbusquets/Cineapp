import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchMoviesEvent extends SearchEvent {
  final String query;
  SearchMoviesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends SearchEvent {}