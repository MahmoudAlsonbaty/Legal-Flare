part of 'last_seen_bloc.dart';

sealed class LastSeenState extends Equatable {
  const LastSeenState();

  @override
  List<Object> get props => [];
}

final class LastSeenInitial extends LastSeenState {}

final class LastSeenLoading extends LastSeenState {}

final class LastSeenError extends LastSeenState {}

final class LastSeenDataRetrieved extends LastSeenState {
  final Map<ArticleModel, Timestamp> articles;
  const LastSeenDataRetrieved(this.articles);
}
