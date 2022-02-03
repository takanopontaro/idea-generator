import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/idea.dart';
import 'package:idea_generator/parts/idea_card.dart';
import 'package:idea_generator/providers.dart';

final _filteredIdeaListProvider = Provider<List<Idea>>((ref) {
  final ideaList = ref.watch(ideaListProvider);
  final themeList = ref.watch(themeListProvider.notifier);
  final keywordList = ref.watch(keywordListProvider.notifier);
  final filterText = ref.watch(filterTextProvider);
  final filterTagList = ref.watch(filterTagListProvider);
  final filterTagIdList = filterTagList.map((tag) => tag.id).toList();

  final filteredIdeaList = ideaList
      .where(
        (idea) => idea.tags.any((tagId) => filterTagIdList.contains(tagId)),
      )
      .toList();

  if (filterText == '') {
    return filteredIdeaList;
  }

  return filteredIdeaList.where((idea) {
    final theme = themeList.getById(idea.themeId).text;
    final keyword = keywordList.getById(idea.keywordId).text;
    final text = theme + keyword + idea.title + idea.description;
    return text.contains(RegExp(filterText, caseSensitive: false));
  }).toList();
});

class IdeaCardList extends HookConsumerWidget {
  const IdeaCardList({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final ideaList = ref.watch(_filteredIdeaListProvider);

    return GridView.builder(
      padding: const EdgeInsets.only(
        top: 20,
        right: 4,
        bottom: 48,
        left: 4,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: ideaList.length,
      itemBuilder: (_, index) {
        final idea = ideaList[index];
        return ProviderScope(
          key: ValueKey(idea.id),
          overrides: [targetIdea.overrideWithValue(idea)],
          child: const IdeaCard(),
        );
      },
    );
  }
}
