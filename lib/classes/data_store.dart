import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/category_list.dart';
import 'package:idea_generator/classes/filter_tag_list.dart';
import 'package:idea_generator/classes/idea_list.dart';
import 'package:idea_generator/classes/keyword_list.dart';
import 'package:idea_generator/classes/tag_list.dart';
import 'package:idea_generator/classes/theme_list.dart';
import 'package:idea_generator/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataStore {
  final WidgetRef ref;

  DataStore(this.ref);

  CategoryList get categoryList => ref.read(categoryListProvider.notifier);

  FilterTagList get filterTagList => ref.read(filterTagListProvider.notifier);

  IdeaList get ideaList => ref.read(ideaListProvider.notifier);

  KeywordList get keywordList => ref.read(keywordListProvider.notifier);

  TagList get tagList => ref.read(tagListProvider.notifier);

  ThemeList get themeList => ref.read(themeListProvider.notifier);

  Future<bool> read() async {
    final res = await Future.wait([
      categoryList.read(),
      filterTagList.read(),
      ideaList.read(),
      keywordList.read(),
      tagList.read(),
      themeList.read(),
    ]);
    if (res.any((success) => !success)) {
      await load();
    }
    return true;
  }

  Future<bool> load() async {
    await Future.wait([
      categoryList.load('assets/category.json'),
      ideaList.load('assets/idea.json'),
      keywordList.load('assets/keyword.json'),
      tagList.load('assets/tag.json'),
      themeList.load('assets/theme.json'),
    ]);
    filterTagList.init();
    return true;
  }

  Future<bool> dummy() async {
    if (categoryList.isNotEmpty) {
      return true;
    }
    await Future.wait([
      categoryList.load('assets/category.json'),
      ideaList.load('assets/dummy/idea.json'),
      keywordList.load('assets/keyword.json'),
      tagList.load('assets/dummy/tag.json'),
      themeList.load('assets/dummy/theme.json'),
    ]);
    filterTagList.init();
    return true;
  }

  Future<void> erase() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
