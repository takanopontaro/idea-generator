import 'package:idea_generator/classes/base_item.dart';

class Category extends BaseItem {
  final String text;
  final bool disabled;

  Category({
    String? id,
    required this.text,
    required this.disabled,
  }) : super(id: id);

  @override
  Category copyWith({String? text, bool? disabled}) {
    return Category(
      id: id,
      text: text ?? this.text,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'disabled': disabled,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      text: map['text'] as String,
      disabled: map['disabled'] as bool,
    );
  }
}
