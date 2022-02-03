import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/keyword.dart';
import 'package:idea_generator/providers.dart';

final _availableKeywordListProvider = Provider<List<Keyword>>((ref) {
  final categoryList = ref.watch(categoryListProvider);
  final keywordList = ref.watch(keywordListProvider);
  final disabledCategoryIdList =
      categoryList.where((cat) => cat.disabled).map((cat) => cat.id).toList();
  return keywordList
      .where((kw) => !disabledCategoryIdList.contains(kw.categoryId))
      .toList();
});

class RamdomWord {
  final Ref ref;

  RamdomWord(this.ref);

  Keyword generate() {
    final keywordList = ref.read(_availableKeywordListProvider);
    return keywordList[Random().nextInt(keywordList.length)];
  }

  void setCurrent() {
    ref.read(currentKeywordProvider.notifier).state = generate();
  }

  void refresh() {
    final animating = ref.read(animatingProvider);
    if (!animating) {
      ref.read(nextKeywordProvider.notifier).state = generate();
      ref.read(animatingProvider.notifier).state = true;
    }
  }

  void checkValidity() {
    final keywordList = ref.read(keywordListProvider.notifier);
    final keyword = ref.read(currentKeywordProvider);
    if (keyword == null) {
      return;
    }
    if (!keywordList.exists(keyword.id)) {
      refresh();
      return;
    }
    final realKeyword = keywordList.getById(keyword.id);
    if (keyword.text != realKeyword.text) {
      ref.read(currentKeywordProvider.notifier).state = realKeyword.copyWith();
    }
  }
}
