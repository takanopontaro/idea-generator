import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/base_list.dart';
import 'package:idea_generator/classes/tag.dart';
import 'package:idea_generator/classes/tag_list.dart';
import 'package:idea_generator/providers.dart';

class FilterTagList extends BaseList<Tag> {
  FilterTagList(Ref ref) : super(ref, 'filter');

  @override
  Tag fromMap(Map<String, dynamic> map) => Tag.fromMap(map);

  void init() {
    final tagList = ref.read(tagListProvider.notifier);
    state = [tagList.clone(TagList.allId)];
    write();
  }

  void refresh(String id) {
    final tagList = ref.read(tagListProvider.notifier);
    state = [
      for (final tag in state)
        if (tag.id == id) tagList.clone(id) else tag
    ];
  }

  int get countEnabled => state.length;

  @override
  bool remove(Tag item) {
    super.remove(item);
    if (isEmpty) {
      init();
    }
    return true;
  }
}
