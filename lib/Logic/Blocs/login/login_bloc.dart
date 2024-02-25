import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_rights/Data/models/user_model.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseRepository firebaseRepository;
  final AuthenticationBloc authenticationBloc;
  LoginBloc(this.firebaseRepository, this.authenticationBloc)
      : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await firebaseRepository.signIn(event.email, event.password);
        int waitTime = 0;
        while (authenticationBloc.state.user.email != event.email) {
          if (waitTime >= 15 * 1000) {
            emit(const LoginFailure(
                "Timed out waiting for authenticationBloc to get user data"));
            return;
          }
          await Future.delayed(const Duration(milliseconds: 100));
          waitTime += 100;
        }
        Map<String, dynamic> data =
            await firebaseRepository.getUserData(authenticationBloc.state.user);
        MyAppUser userWithData = MyAppUser.fromMap(data);
        authenticationBloc.add(AuthenticationUserChanged(userWithData));
        waitTime = 0;
        while (authenticationBloc.state.user != userWithData) {
          if (waitTime >= 15 * 1000) {
            emit(const LoginFailure(
                "Timed out waiting for authenticationBloc to update user data"));
            return;
          }
          await Future.delayed(const Duration(milliseconds: 100));
          waitTime += 100;
        }
        emit(LoginSuccess());
      } catch (e) {
        //TODO: Handle Different Errors Such as No User Data Found or No Login data
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
