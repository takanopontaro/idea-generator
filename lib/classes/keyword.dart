import 'package:idea_generator/classes/base_item.dart';

class Keyword extends BaseItem {
  final String text;
  final String categoryId;

  Keyword({
    String? id,
    required this.text,
    required this.categoryId,
  }) : super(id: id);

  @override
  Keyword copyWith({String? text, String? kana}) {
    return Keyword(
      id: id,
      text: text ?? this.text,
      categoryId: categoryId,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'categoryId': categoryId,
    };
  }

  factory Keyword.fromMap(Map<String, dynamic> map) {
    return Keyword(
      id: map['id'] as String,
      text: map['text'] as String,
      categoryId: map['categoryId'] as String,
    );
  }
}
