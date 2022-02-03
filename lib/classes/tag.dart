import 'package:idea_generator/classes/base_item.dart';

class Tag extends BaseItem {
  final String text;

  Tag({String? id, required this.text}) : super(id: id);

  @override
  Tag copyWith({String? text}) {
    return Tag(
      id: id,
      text: text ?? this.text,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'] as String,
      text: map['text'] as String,
    );
  }
}
