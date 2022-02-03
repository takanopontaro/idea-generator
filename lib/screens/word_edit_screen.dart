import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/category_list.dart';
import 'package:idea_generator/classes/keyword.dart';
import 'package:idea_generator/palette.dart' as palette;
import 'package:idea_generator/providers.dart';

final _userKeywordListProvider = Provider<List<Keyword>>((ref) {
  final keywordList = ref.watch(keywordListProvider);
  return keywordList
      .where((kw) => kw.categoryId == CategoryList.userKeywordId)
      .toList();
});

class WordEditScreen extends HookConsumerWidget {
  const WordEditScreen({Key? key}) : super(key: key);

  void showDeleteDialog(BuildContext context, Keyword keyword, WidgetRef ref) {
    final keywordList = ref.read(keywordListProvider.notifier);
    final randomWord = ref.read(randomWordProvider);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text('キーワードを削除します。よろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final success = keywordList.remove(keyword);
              Navigator.pop(context, 'OK');
              if (success) {
                randomWord.checkValidity();
                return;
              }
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: const Text('削除できませんでした。このキーワードを使用しているアイディアがあります。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showEditDialog(
    BuildContext context,
    TextEditingController controller,
    Widget okWidget,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('キーワードを入力してください。'),
            TextField(controller: controller),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          okWidget,
        ],
      ),
    );
  }

  @override
  Widget build(context, ref) {
    final keywordList = ref.watch(keywordListProvider.notifier);
    final userKeywordList = ref.watch(_userKeywordListProvider);
    final randomWord = ref.watch(randomWordProvider);
    final controller = useTextEditingController();

    final isKeywordValid = useCallback(() {
      final text = controller.text.trim();
      final exists =
          keywordList.keywordExists(text, CategoryList.userKeywordId);
      return text.isNotEmpty && !exists;
    }, [controller]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('追加キーワードの編集'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              controller.clear();
              showEditDialog(
                context,
                controller,
                TextButton(
                  onPressed: () {
                    if (!isKeywordValid()) {
                      return;
                    }
                    final keyword = Keyword(
                      text: controller.text.trim(),
                      categoryId: CategoryList.userKeywordId,
                    );
                    keywordList.add(keyword);
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userKeywordList.length,
        itemBuilder: (_, index) {
          final keyword = userKeywordList[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => showDeleteDialog(context, keyword, ref),
                  backgroundColor: palette.red,
                  foregroundColor: palette.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  spacing: 6,
                ),
                SlidableAction(
                  onPressed: (_) {
                    controller.text = keyword.text;
                    showEditDialog(
                      context,
                      controller,
                      TextButton(
                        onPressed: () {
                          if (!isKeywordValid()) {
                            return;
                          }
                          keywordList.edit(
                            id: keyword.id,
                            text: controller.text.trim(),
                          );
                          randomWord.checkValidity();
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    );
                  },
                  backgroundColor: palette.orange,
                  foregroundColor: palette.white,
                  icon: Icons.edit,
                  label: 'Edit',
                  spacing: 6,
                ),
              ],
            ),
            child: ListTile(title: Text(keyword.text)),
          );
        },
      ),
    );
  }
}
