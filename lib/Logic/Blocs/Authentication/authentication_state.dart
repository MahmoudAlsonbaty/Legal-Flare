part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  const AuthenticationState._(this.user, this.status);
  final MyAppUser user;
  final AuthenticationStatus status;

  const AuthenticationState.authenticated(MyAppUser user)
      : this._(user, AuthenticationStatus.authenticated);
  AuthenticationState.unauthenticated()
      : this._(MyAppUser.empty(), AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [user, status];
}
