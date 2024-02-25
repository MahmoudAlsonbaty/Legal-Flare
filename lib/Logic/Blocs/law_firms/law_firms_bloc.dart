import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_rights/Data/models/law_firm_model.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';

part 'law_firms_event.dart';
part 'law_firms_state.dart';

class LawFirmsBloc extends Bloc<LawFirmsEvent, LawFirmsState> {
  final FirebaseRepository _firebaseRepository;
  LawFirmsBloc(this._firebaseRepository) : super(LawFirmsLoading()) {
    on<LawFirmsGetLawFirmsFromDatabase>((event, emit) async {
      emit(LawFirmsLoading());
      await _firebaseRepository.getLawFirms().then((lawFirms) {
        if (lawFirms.isNotEmpty) {
          emit(LawFirmsRetrieved(lawFirms: lawFirms));
        } else {
          emit(LawFirmsFailed());
        }
      });
    });
  }
}
