part of 'law_firms_bloc.dart';

sealed class LawFirmsEvent extends Equatable {
  const LawFirmsEvent();

  @override
  List<Object> get props => [];
}

class LawFirmsGetLawFirmsFromDatabase extends LawFirmsEvent {}
