part of 'explore_bloc.dart';

sealed class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

final class ExploreInitial extends ExploreState {}

final class ExploreLoading extends ExploreState {}

final class ExploreLoaded extends ExploreState {
  final List<ArticleModel> articles;

  ExploreLoaded({required this.articles});
}
