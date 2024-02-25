part of 'smart_help_bloc.dart';

sealed class SmartHelpState extends Equatable {
  const SmartHelpState();

  @override
  List<Object> get props => [];
}

final class SmartHelpInitial extends SmartHelpState {}

final class SmartHelpLoading extends SmartHelpState {
  final String userPrompt;

  SmartHelpLoading({required this.userPrompt});
}

final class SmartHelpDataRetrieved extends SmartHelpState {
  final List<ArticleModel> articles;
  final String userPrompt;
  const SmartHelpDataRetrieved(this.articles, this.userPrompt);
}

final class SmartHelpError extends SmartHelpState {}
