part of 'did_you_know_bloc.dart';

sealed class DidYouKnowEvent extends Equatable {
  const DidYouKnowEvent();

  @override
  List<Object> get props => [];
}

class DidYouKnowGetFact extends DidYouKnowEvent {}

class DidYouKnowGetFromDatabase extends DidYouKnowEvent {}
