import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:your_rights/Data/models/user_model.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>
    with ChangeNotifier {
  final FirebaseRepository firebaseRepository;
  late final StreamSubscription<MyAppUser> _streamSubscription;

  AuthenticationBloc({
    required this.firebaseRepository,
  }) : super(AuthenticationState.unauthenticated()) {
    _streamSubscription = firebaseRepository.user.listen((user) {
      log("===THE AUTHENTICATION LISTENER HAS BEEN NOTIFIED WITH A CHANGE===",
          name: "Auth BLOC");
      add(AuthenticationUserChanged(user));
    });
    on<AuthenticationUserChanged>((event, emit) async {
      if (event.user.isEmpty) {
        emit(AuthenticationState.unauthenticated());
      } else {
        await firebaseRepository.getUserData(event.user).then((value) {
          emit(AuthenticationState.authenticated(MyAppUser.fromMap(value)));
        });
      }
      notifyListeners();
    });
    on<AuthenticationLogoutRequested>((event, emit) {
      firebaseRepository.signOut();
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
