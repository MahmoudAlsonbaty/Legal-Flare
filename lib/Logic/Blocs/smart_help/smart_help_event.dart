part of 'smart_help_bloc.dart';

sealed class SmartHelpEvent extends Equatable {
  const SmartHelpEvent();

  @override
  List<Object> get props => [];
}

class SmartHelpGetLaws extends SmartHelpEvent {
  final String userPrompt;
  const SmartHelpGetLaws(this.userPrompt);
}
