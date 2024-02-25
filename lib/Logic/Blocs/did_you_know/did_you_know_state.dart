part of 'did_you_know_bloc.dart';

sealed class DidYouKnowState extends Equatable {
  const DidYouKnowState();

  @override
  List<Object> get props => [];
}

final class DidYouKnowLoading extends DidYouKnowState {}

final class DidYouKnowFactReceived extends DidYouKnowState {
  final String title;
  final String body;

  const DidYouKnowFactReceived({required this.title, required this.body});
}

final class DidYouKnowFactError extends DidYouKnowState {}
