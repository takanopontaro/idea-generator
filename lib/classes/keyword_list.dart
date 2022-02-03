import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/base_list.dart';
import 'package:idea_generator/classes/keyword.dart';
import 'package:idea_generator/providers.dart';

class KeywordList extends BaseList<Keyword> {
  KeywordList(Ref ref) : super(ref, 'keyword');

  @override
  Keyword fromMap(Map<String, dynamic> map) => Keyword.fromMap(map);

  bool keywordExists(String text, String categoryId) =>
      state.any((kw) => kw.text == text && kw.categoryId == categoryId);

  void edit({required String id, String? text}) {
    state = [
      for (final keyword in state)
        if (keyword.id == id) keyword.copyWith(text: text) else keyword
    ];
  }

  @override
  bool remove(Keyword item) {
    final unremovable =
        ref.read(ideaListProvider).any((idea) => idea.tags.contains(item.id));
    if (unremovable) {
      return false;
    }
    super.remove(item);
    return true;
  }
}
