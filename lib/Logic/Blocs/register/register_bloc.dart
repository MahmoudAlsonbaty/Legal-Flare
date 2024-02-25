import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_rights/Data/models/user_model.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseRepository firebaseRepository;
  final AuthenticationBloc authenticationBloc;
  RegisterBloc(this.firebaseRepository, this.authenticationBloc)
      : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(RegisterLoading());
      await firebaseRepository
          .signUp(event.user, event.password)
          .then((user) => emit(RegisterSuccess()))
          .catchError((error) => emit(RegisterFailure(error.toString())));
    });

    on<RegisterDataUpdate>((event, emit) async {
      emit(RegisterLoading());
      try {
        await firebaseRepository.updateUserData(event.user);
        authenticationBloc.add(AuthenticationUserChanged(event.user));
        int waitTime = 0;
        while (authenticationBloc.state.user == event.user) {
          if (waitTime >= 15 * 1000) {
            emit(const RegisterDataUpdateFailure(
                "Timed out waiting for authenticationBloc to update user data"));
            return;
          }
          await Future.delayed(const Duration(milliseconds: 100));
          waitTime += 100;
        }
        emit(RegisterDateUpdateSuccess());
      } catch (e) {
        emit(RegisterDataUpdateFailure(e.toString()));
      }
    });

    on<RegisterSendEmailConfirm>((event, emit) async {
      emit(RegisterLoading());
      await firebaseRepository
          .sendEmailConfirmation()
          .then((user) => emit(RegisterConfirmEmailSentSuccessfully()))
          .catchError((error) =>
              emit(RegisterConfirmEmailSentFailure(error.toString())));
    });

    on<RegisterCheckEmailConfirmed>((event, emit) async {
      // bool res = await firebaseRepository.getUserEmailConfirmed();
      // if (res) {
      //   emit(RegisterConfirmEmailConfirmed());
      // } else {
      //   emit(RegisterConfirmEmailNotConfirmed());
      // }
      emit(RegisterLoading());
      await firebaseRepository.getUserEmailConfirmed().then((res) {
        if (res) {
          emit(RegisterConfirmEmailConfirmed());
        } else {
          emit(const RegisterConfirmEmailNotConfirmed("Email Not Confirmed"));
        }
      }).catchError((error) {
        emit(RegisterConfirmEmailNotConfirmed(error.toString()));
      });
    });

    on<RegisterUpdateUI>((event, emit) async {
      emit(RegisterUpdateUIState(event.data));
    });
  }
}
