part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => ["RegisterInitial"];
}

final class RegisterLoading extends RegisterState {
  @override
  List<Object> get props => ["RegisterLoading"];
}

final class RegisterSuccess extends RegisterState {
  @override
  List<Object> get props => ["RegisterSuccess"];
}

final class RegisterUpdateUIState extends RegisterState {
  final String data;

  const RegisterUpdateUIState(this.data);

  @override
  List<Object> get props => [data];
}

final class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class RegisterDateUpdateSuccess extends RegisterState {
  @override
  List<Object> get props => ["RegisterDateUpdateSuccess"];
}

final class RegisterDataUpdateFailure extends RegisterState {
  final String error;

  const RegisterDataUpdateFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class RegisterConfirmEmailSentSuccessfully extends RegisterState {
  @override
  List<Object> get props => ["RegisterConfirmEmailSuccess"];
}

final class RegisterConfirmEmailSentFailure extends RegisterState {
  final String error;

  const RegisterConfirmEmailSentFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class RegisterConfirmEmailConfirmed extends RegisterState {
  @override
  List<Object> get props => ["RegisterConfirmEmailConfirmed"];
}

final class RegisterConfirmEmailNotConfirmed extends RegisterState {
  final String error;

  const RegisterConfirmEmailNotConfirmed(this.error);

  @override
  List<Object> get props => [error];
}
