import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/category.dart';
import 'package:idea_generator/classes/category_list.dart';
import 'package:idea_generator/classes/filter_tag_list.dart';
import 'package:idea_generator/classes/idea.dart';
import 'package:idea_generator/classes/idea_list.dart';
import 'package:idea_generator/classes/image_handler.dart';
import 'package:idea_generator/classes/keyword.dart';
import 'package:idea_generator/classes/keyword_list.dart';
import 'package:idea_generator/classes/random_word.dart';
import 'package:idea_generator/classes/tag.dart';
import 'package:idea_generator/classes/tag_list.dart';
import 'package:idea_generator/classes/theme.dart';
import 'package:idea_generator/classes/theme_list.dart';

final targetIdea = Provider<Idea>((_) => throw UnimplementedError());

final shakingProvider = StateProvider<bool>((_) => false);

final ideaListProvider =
    StateNotifierProvider<IdeaList, List<Idea>>((ref) => IdeaList(ref));

final tagListProvider =
    StateNotifierProvider<TagList, List<Tag>>((ref) => TagList(ref));

final strictTagListProvider = Provider<List<Tag>>((ref) {
  final tagList = ref.watch(tagListProvider);
  return tagList
      .where((kw) => !ref.read(tagListProvider.notifier).isSpecialTag(kw.id))
      .toList();
});

final filterTagListProvider = StateNotifierProvider<FilterTagList, List<Tag>>(
    (ref) => FilterTagList(ref));

final categoryListProvider =
    StateNotifierProvider<CategoryList, List<Category>>(
        (ref) => CategoryList(ref));

final keywordListProvider = StateNotifierProvider<KeywordList, List<Keyword>>(
    (ref) => KeywordList(ref));

final themeListProvider =
    StateNotifierProvider<ThemeList, List<Theme>>((ref) => ThemeList(ref));

final filterTextProvider = StateProvider<String>((_) => '');

final currentThemeProvider = StateProvider<String>((_) => '');

final currentKeywordProvider = StateProvider<Keyword?>((_) => null);

final nextKeywordProvider = StateProvider<Keyword?>((_) => null);

final animatingProvider = StateProvider<bool>((_) => false);

final currentIdeaProvider = StateProvider<Idea?>((_) => null);

final randomWordProvider = StateProvider<RamdomWord>((ref) => RamdomWord(ref));

final imageHandlerProvider = Provider<ImageHandler>((ref) => ImageHandler(ref));
