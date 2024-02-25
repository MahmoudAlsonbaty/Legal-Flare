import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_rights/Data/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:your_rights/Data/repositories/firebase_repo.dart';
import 'package:your_rights/Logic/Blocs/Authentication/authentication_bloc.dart';

part 'smart_help_event.dart';
part 'smart_help_state.dart';

class SmartHelpBloc extends Bloc<SmartHelpEvent, SmartHelpState> {
  final FirebaseRepository _firebaseRepository;
  SmartHelpBloc(this._firebaseRepository) : super(SmartHelpInitial()) {
    on<SmartHelpGetLaws>((event, emit) async {
      emit(SmartHelpLoading(userPrompt: event.userPrompt));
      try {
        //!Translate First
        String userPrompt = event.userPrompt;
        String cloudFuncTranslateUrl =
            "https://us-central1-solutionchallenge2024-cb8e1.cloudfunctions.net/getTranslation";
        final translateResponse = await http.post(
          Uri.parse(cloudFuncTranslateUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'prompt': userPrompt,
          }),
        );
        log("Response CODE : ${translateResponse.statusCode}");
        String userPromptTranslated = "";
        if (translateResponse.statusCode == 200) {
          // If the server did return a 200 response then parse the JSON,
          log('Response JSON: ${translateResponse.body}');
          Map<String, dynamic> data = jsonDecode(translateResponse.body);
          userPromptTranslated = data['response'];
        }
        //!END Translate

        String cloudFuncUrl = "https://gettags-dmopggq2qq-uc.a.run.app";
        final response = await http.post(
          Uri.parse(cloudFuncUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'prompt': userPromptTranslated,
          }),
        );
        log("Response CODE : ${response.statusCode}");
        if (response.statusCode == 200) {
          // If the server did return a 200 response then parse the JSON,
          log('Response JSON: ${response.body}');
          Map<String, dynamic> data = jsonDecode(response.body);
          String Response = data['response'];
          log('Response JSON DECODED ${Response}');

          if (Response.contains("[") && Response.contains("]")) {
            Response = Response.replaceAll(RegExp(r'[\[\],]'), '');
            List<String> tags = Response.split(' ');
            log("TAGS LIST:${tags.toString()}");
            List<ArticleModel> articles =
                await _firebaseRepository.getArticles(tags);
            log("ARTICLES LIST COUNT:${articles.length}");
            emit(SmartHelpDataRetrieved(articles, event.userPrompt));
          } else {
            //TODO: throw an error
            emit(SmartHelpDataRetrieved([], event.userPrompt));
          }

          emit(SmartHelpDataRetrieved([], event.userPrompt));
        } else {
          log('FAILED TO GET RESPONSE: ${response.body}');
          // emit(const SmartHelpDataRetrieved([]));
        }
      } catch (e) {
        log("Error in SmartHelpBloc: ${e.toString()}", name: "SmartHelpBloc");
        emit(SmartHelpError());
      }
    });
  }
}
