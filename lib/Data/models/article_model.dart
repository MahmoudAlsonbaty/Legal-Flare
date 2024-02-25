import 'package:equatable/equatable.dart';

class ArticleModel extends Equatable {
  final String title;
  final String body;
  final String id;

  ArticleModel({
    required this.title,
    required this.body,
    required this.id,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> map, String id) {
    return ArticleModel(
      title: map['title'],
      body: map['body'],
      id: id,
    );
  }
  factory ArticleModel.empty() {
    return ArticleModel(
      title: "",
      body: "",
      id: "",
    );
  }

  @override
  List<Object?> get props => [title, body, id];
}
