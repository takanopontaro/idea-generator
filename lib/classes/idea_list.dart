import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/base_list.dart';
import 'package:idea_generator/classes/idea.dart';
import 'package:idea_generator/classes/tag.dart';
import 'package:idea_generator/classes/tag_list.dart';
import 'package:idea_generator/providers.dart';

class IdeaList extends BaseList<Idea> {
  IdeaList(Ref ref) : super(ref, 'idea');

  @override
  Idea fromMap(Map<String, dynamic> map) => Idea.fromMap(map);

  void sort() {
    state.sort((a, b) => b.updated.compareTo(a.updated));
  }

  @override
  bool add(item) {
    final res = super.add(item);
    sort();
    write();
    return res;
  }

  @override
  bool addAll(items) {
    final res = super.addAll(items);
    sort();
    write();
    return res;
  }

  @override
  bool remove(item) {
    final count =
        state.where((idea) => idea.themeId == item.themeId).toList().length;
    if (count == 1) {
      final themeList = ref.read(themeListProvider.notifier);
      final theme = themeList.getById(item.themeId);
      themeList.remove(theme);
    }
    if (item.image) {
      ref.read(imageHandlerProvider).removePhotoById(item.id);
    }
    super.remove(item);
    return true;
  }

  void edit({
    required String id,
    DateTime? updated,
    String? title,
    String? description,
    String? themeId,
    String? keywordId,
    List<String>? tags,
    bool? image,
  }) {
    state = [
      for (final idea in state)
        if (idea.id == id)
          idea.copyWith(
            updated: updated,
            title: title,
            description: description,
            themeId: themeId,
            keywordId: keywordId,
            tags: tags,
            image: image,
          )
        else
          idea
    ];
    if (updated != null) {
      sort();
    }
    write();
  }

  void toggleFavorite(String id) {
    final idea = getById(id);
    final tagId = TagList.favoriteId;
    if (idea.isFavorite) {
      idea.tags.remove(tagId);
    } else {
      idea.tags.add(tagId);
    }
    edit(id: id, tags: [...idea.tags]);
  }

  void detachTagAll(Tag tag) {
    state = [
      for (final idea in state)
        if (idea.hasTag(tag))
          idea.copyWith(
            tags: idea.tags.where((tagId) => tagId != tag.id).toList(),
          )
        else
          idea
    ];
    write();
  }
}
