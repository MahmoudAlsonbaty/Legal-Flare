import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'did_you_know_event.dart';
part 'did_you_know_state.dart';

class DidYouKnowBloc extends Bloc<DidYouKnowEvent, DidYouKnowState> {
  List<Map<String, String>> _facts = [];
  int currentSelectedFact = 0;
  DidYouKnowBloc() : super(DidYouKnowLoading()) {
    on<DidYouKnowGetFromDatabase>(
      (event, emit) async {
        emit(DidYouKnowLoading());
        try {
          //TODO: Implement Different Languages
          String _CollectionName = "RandomFacts_ar";
          final _ref = FirebaseFirestore.instance.collection(_CollectionName);
          final res = await _ref.get();
          res.docs.forEach((element) {
            _facts.add(Map<String, String>.from(element.data()));
          });
          emit(DidYouKnowFactReceived(
              title: _facts[currentSelectedFact]["title"]!,
              body: _facts[currentSelectedFact]["body"]!));
          currentSelectedFact++;
        } catch (e) {
          log(e.toString(), name: "DidYouKnowBloc ERROR");
        }
      },
    );
    on<DidYouKnowGetFact>((event, emit) async {
      emit(DidYouKnowLoading());
      if (currentSelectedFact < _facts.length) {
        emit(DidYouKnowFactReceived(
            title: _facts[currentSelectedFact]["title"]!,
            body: _facts[currentSelectedFact]["body"]!));
        currentSelectedFact++;
      } else {
        emit(DidYouKnowFactReceived(
            title: _facts[0]["title"]!, body: _facts[0]["body"]!));
        currentSelectedFact = 0;
      }
    });
  }
}
