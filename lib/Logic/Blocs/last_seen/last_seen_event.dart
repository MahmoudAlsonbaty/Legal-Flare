part of 'last_seen_bloc.dart';

sealed class LastSeenEvent extends Equatable {
  const LastSeenEvent();

  @override
  List<Object> get props => [];
}

class LastSeenGetLastSeen extends LastSeenEvent {
  const LastSeenGetLastSeen();
}

class LastSeenUpdateLastSeen extends LastSeenEvent {
  final ArticleModel article;
  const LastSeenUpdateLastSeen(this.article);
}
