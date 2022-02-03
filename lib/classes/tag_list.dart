import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/base_list.dart';
import 'package:idea_generator/classes/tag.dart';
import 'package:idea_generator/providers.dart';

class TagList extends BaseList<Tag> {
  static const String allId = '0';
  static const String favoriteId = '1';

  TagList(Ref ref) : super(ref, 'tag');

  @override
  Tag fromMap(Map<String, dynamic> map) => Tag.fromMap(map);

  bool tagExists(String text) => state.any((tag) => tag.text == text);

  bool isSpecialTag(String id) => id == allId || id == favoriteId;

  void edit({required String id, String? text}) {
    state = [
      for (final tag in state)
        if (tag.id == id) tag.copyWith(text: text) else tag
    ];
    ref.read(filterTagListProvider.notifier).refresh(id);
    write();
  }

  @override
  bool add(Tag item) {
    super.add(item);
    ref.read(filterTagListProvider.notifier).add(item);
    return true;
  }

  @override
  bool addAll(List<Tag> items) {
    super.addAll(items);
    ref.read(filterTagListProvider.notifier).addAll(items);
    return true;
  }

  @override
  bool remove(Tag item) {
    super.remove(item);
    ref.read(ideaListProvider.notifier).detachTagAll(item);
    ref.read(filterTagListProvider.notifier).remove(item);
    return true;
  }
}
