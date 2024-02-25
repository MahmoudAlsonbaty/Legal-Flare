part of 'explore_bloc.dart';

sealed class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class ExploreGetArticlesFromDatabase extends ExploreEvent {
  final String userSearch;
  final List<String> userTags;

  ExploreGetArticlesFromDatabase(
      {required this.userSearch, required this.userTags});
}
