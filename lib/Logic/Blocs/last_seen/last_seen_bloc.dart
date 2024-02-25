import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:your_rights/Data/models/article_model.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';

part 'last_seen_event.dart';
part 'last_seen_state.dart';

class LastSeenBloc extends Bloc<LastSeenEvent, LastSeenState> {
  final FirebaseRepository _firebaseRepository;
  final AuthenticationBloc _authBloc;
  LastSeenBloc(this._firebaseRepository, this._authBloc)
      : super(LastSeenInitial()) {
    on<LastSeenGetLastSeen>((event, emit) async {
      emit(LastSeenLoading());
      try {
        Map<String, Timestamp> articleIDs =
            await _firebaseRepository.getLastSeenArticles(_authBloc.state.user);

        Map<ArticleModel, Timestamp> articlesList = {};
        for (var entry in articleIDs.entries) {
          ArticleModel article =
              await _firebaseRepository.getArticle(entry.key);
          articlesList[article] = entry.value;
        }
        emit(LastSeenDataRetrieved(articlesList));
      } catch (e) {
        emit(LastSeenError());
      }
    });

    on<LastSeenUpdateLastSeen>((event, emit) async {
      ArticleModel article = event.article;
      await _firebaseRepository.updateLastSeenArticle(
          _authBloc.state.user, article);
      add(const LastSeenGetLastSeen());
    });
  }
}
