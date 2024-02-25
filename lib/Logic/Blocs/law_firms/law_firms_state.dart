part of 'law_firms_bloc.dart';

sealed class LawFirmsState extends Equatable {
  const LawFirmsState();

  @override
  List<Object> get props => [];
}

final class LawFirmsLoading extends LawFirmsState {}

final class LawFirmsRetrieved extends LawFirmsState {
  final List<LawFirm> lawFirms;

  LawFirmsRetrieved({required this.lawFirms});
}

final class LawFirmsFailed extends LawFirmsState {}
