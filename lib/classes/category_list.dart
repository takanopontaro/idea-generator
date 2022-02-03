import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/base_list.dart';
import 'package:idea_generator/classes/category.dart';

class CategoryList extends BaseList<Category> {
  static const String userKeywordId = '0';

  CategoryList(Ref ref) : super(ref, 'category');

  @override
  Category fromMap(Map<String, dynamic> map) => Category.fromMap(map);

  void edit({required String id, String? text, bool? disabled}) {
    state = [
      for (final category in state)
        if (category.id == id)
          category.copyWith(text: text, disabled: disabled)
        else
          category
    ];
    write();
  }

  int get countEnabled => state.where((cat) => !cat.disabled).length;
}
