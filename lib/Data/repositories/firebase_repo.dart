import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_rights/Data/models/article_model.dart';
import 'package:your_rights/Data/models/law_firm_model.dart';
import 'package:your_rights/Data/models/user_model.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';
import 'package:http/http.dart' as http;

class FirebaseRepository {
  FirebaseAuth _firebaseAuth;
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _articlesCollection = FirebaseFirestore.instance.collection('Articles');
  final _lawFirmsCollection = FirebaseFirestore.instance.collection('LawFirms');
  FirebaseRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Stream<MyAppUser> get user {
    //This used to be authStateChanges but i changed it to userChanges to cover all update
    return _firebaseAuth.userChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        log("=== NO USER WAS FOUND AND MAKING AN EMPTY USER ===",
            name: "Firebase User Stream");
        return MyAppUser.empty();
      } else {
        log("=== A USER WAS FOUND AND MAKING IT FROM FIREBASE USER ===",
            name: "Firebase User Stream");
        return MyAppUser.fromFirebaseUser(firebaseUser);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<MyAppUser> signUp(MyAppUser myUser, String password) async {
    try {
      UserCredential fireUser =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: myUser.email, password: password);

      myUser = myUser.copyWith(userID: fireUser.user!.uid);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> updateUserData(MyAppUser myUser) async {
    try {
      await _usersCollection.doc(myUser.userID).set(myUser.toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserData(MyAppUser user) async {
    try {
      if (user.isEmpty) {
        return user.toMap();
      }

      DocumentSnapshot Data = await _usersCollection.doc(user.userID).get();
      if (!Data.exists) {
        return user.toMap();
      }
      Map<String, dynamic> data = Data.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      log(e.toString(), name: "Firebase Repository getUserData");
      rethrow;
    }
  }

  Future<void> sendEmailConfirmation() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> getUserEmailConfirmed() async {
    try {
      log("=== GETTING USER EMAIL CONFIRMATION STATUS ===");
      await _firebaseAuth.currentUser?.reload();
      bool? res = _firebaseAuth.currentUser?.emailVerified;
      return res ?? false;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<String>> getLastSeen(AuthenticationBloc authBloc) async {
    if (authBloc.state.status == AuthenticationStatus.unauthenticated) {
      return Future.value([]);
    }
    final userData =
        await _usersCollection.doc(authBloc.state.user.userID).get();
    if (userData.exists && userData.data()!.containsKey("lastSeen")) {
      return Future.value(userData.data()!["lastSeen"] as List<String>);
    } else {
      return Future.value([]);
    }
  }

  Future<List<ArticleModel>> getArticles(List<String>? tags) async {
    try {
      if (tags == null || tags.isEmpty) {
        return Future.value([]);
      }
      List<ArticleModel> articles = [];
      await _articlesCollection
          .where("tags", arrayContainsAny: tags)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          articles.add(ArticleModel.fromMap(element.data(), element.id));
        });
      });
      return articles;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> updateLastSeenArticle(
    MyAppUser user,
    ArticleModel article,
  ) async {
    if (user.isEmpty || !user.hasInfo) {
      return;
    }

    try {
      Map<String, dynamic> currentUserData =
          (await _usersCollection.doc(user.userID).get()).data()
              as Map<String, dynamic>;
      if (!currentUserData.containsKey("lastSeen")) {
        await _usersCollection.doc(user.userID).update({
          "lastSeen": {article.id: Timestamp.fromDate(DateTime.now())}
        });
        return;
      }
      Map<String, dynamic> oldLastSeen =
          currentUserData["lastSeen"] as Map<String, dynamic>;

      if (oldLastSeen.length < 3 || oldLastSeen.containsKey(article.id)) {
        oldLastSeen[article.id] = Timestamp.fromDate(DateTime.now());
        await _usersCollection
            .doc(user.userID)
            .update({"lastSeen": oldLastSeen});
        return;
      }

      List<dynamic> sorted = oldLastSeen.values.toList()..sort();
      Map<String, dynamic> newLastSeen = {};
      oldLastSeen.forEach((key, value) {
        if (value == sorted.first) {
          newLastSeen[article.id] = Timestamp.fromDate(DateTime.now());
        } else {
          newLastSeen[key] = value;
        }
      });
      await _usersCollection.doc(user.userID).update({"lastSeen": newLastSeen});
      return;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, Timestamp>> getLastSeenArticles(
    MyAppUser user,
  ) async {
    if (user.isEmpty || !user.hasInfo) {
      return {};
    }
    try {
      Map<String, dynamic> currentUserData =
          (await _usersCollection.doc(user.userID).get()).data()
              as Map<String, dynamic>;
      if (!currentUserData.containsKey("lastSeen")) {
        return {};
      }
      Map<String, dynamic> lastSeen =
          currentUserData["lastSeen"] as Map<String, dynamic>;

      return lastSeen.map((key, value) => MapEntry(key, value as Timestamp));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<ArticleModel> getArticle(String articleID) async {
    ArticleModel article;
    DocumentSnapshot doc = await _articlesCollection.doc(articleID).get();
    if (doc.exists) {
      article =
          ArticleModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      return article;
    } else {
      return ArticleModel.empty();
    }
  }

  Future<List<String>> getArticlesBySearch(String term) async {
    log("Called GetBySearchTerm with term: $term", name: "FirebaseRepository");
    try {
      String cloudFuncUrl =
          "https://us-central1-solutionchallenge2024-cb8e1.cloudfunctions.net/getDocuments";
      final response = await http.post(
        Uri.parse(cloudFuncUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'prompt': term,
        }),
      );

      log("Response CODE : ${response.statusCode}");
      if (response.statusCode == 200) {
        // If the server did return a 200 response then parse the JSON,
        log('Response JSON: ${response.body}');
        Map<String, dynamic> data = jsonDecode(response.body);
        List<String> Response = (data['response'] as List<dynamic>)
            .map((item) => item.toString())
            .toList();
        ;
        log('Response JSON DECODED ${Response}');
        return Response;
      } else {
        log('FAILED TO GET RESPONSE: ${response.body}');
      }
    } catch (e) {
      log("Error in GetBySearchTerm ${e.toString()}",
          name: "FirebaseRepository");
    }
    return [];
  }

  Future<List<LawFirm>> getLawFirms() async {
    List<LawFirm> lawFirms = [];
    await _lawFirmsCollection.get().then((value) {
      value.docs.forEach((element) {
        final data = element.data();
        lawFirms.add(LawFirm(
            name: data['name'],
            location: data['location'],
            telephone: data['telephone']));
      });
    });
    return lawFirms;
  }

  Future<List<ArticleModel>> getArticlesByTag(List<String> userTags) async {
    var queryResult = await _articlesCollection
        .where('tags', arrayContainsAny: userTags)
        .get();
    if (queryResult.size > 0) {
      List<ArticleModel> articles = queryResult.docs
          .map((e) =>
              ArticleModel.fromMap(e.data() as Map<String, dynamic>, e.id))
          .toList();
      return articles;
    }
    return [];
  }
}
