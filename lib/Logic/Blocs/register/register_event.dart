part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final MyAppUser user;
  final String password;

  const RegisterRequested({
    required this.user,
    required this.password,
  });

  @override
  List<Object> get props => [user];
}

class RegisterUpdateUI extends RegisterEvent {
  final String data;

  const RegisterUpdateUI({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class RegisterSendEmailConfirm extends RegisterEvent {}

class RegisterCheckEmailConfirmed extends RegisterEvent {}

class RegisterDataUpdate extends RegisterEvent {
  final MyAppUser user;

  const RegisterDataUpdate({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}
