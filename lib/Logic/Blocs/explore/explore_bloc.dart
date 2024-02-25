import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:your_rights/Data/models/article_model.dart';
import 'package:your_rights/Data/repositories/firebase_repo.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final FirebaseRepository _firebaseRepository;
  ExploreBloc(this._firebaseRepository) : super(ExploreLoading()) {
    on<ExploreGetArticlesFromDatabase>(
      (event, emit) async {
        final String userSearch = event.userSearch;
        final List<String> userTags = event.userTags;
        emit(ExploreLoading());

        if (userSearch.isEmpty && userTags.isNotEmpty) {
          final articles = await _firebaseRepository.getArticlesByTag(userTags);
          emit(ExploreLoaded(articles: articles));
        } else if (userSearch.isEmpty && userTags.isEmpty) {
          final articles = await _firebaseRepository.getArticlesByTag(
              ["wage", "fired", "inheritance", "debt", "work", "taxes"]);
          emit(ExploreLoaded(articles: articles));
        } else if (userSearch.isNotEmpty && userTags.isEmpty) {
          List<String> articleIDs =
              await _firebaseRepository.getArticlesBySearch(userSearch);
          List<ArticleModel> articles = [];
          for (var id in articleIDs) {
            final article = await _firebaseRepository.getArticle(id);
            articles.add(article);
          }

          return emit(ExploreLoaded(articles: articles));
        } else if (userSearch.isNotEmpty && userTags.isNotEmpty) {
          final articlesByTag =
              await _firebaseRepository.getArticlesByTag(userTags);
          final List<ArticleModel> articles = [];
          List<String> articleIDs =
              await _firebaseRepository.getArticlesBySearch(userSearch);
          for (var article in articlesByTag) {
            if (articleIDs.contains(article.id)) {
              articles.add(article);
            }
          }
          emit(ExploreLoaded(articles: articles));
        } else {
          emit(ExploreLoaded(articles: []));
        }
      },
    );
  }
}
