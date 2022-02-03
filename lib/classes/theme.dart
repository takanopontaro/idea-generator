import 'package:idea_generator/classes/base_item.dart';

class Theme extends BaseItem {
  final String text;

  Theme({String? id, required this.text}) : super(id: id);

  @override
  Theme copyWith({String? text}) {
    return Theme(
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

  factory Theme.fromMap(Map<String, dynamic> map) {
    return Theme(
      id: map['id'] as String,
      text: map['text'] as String,
    );
  }
}
