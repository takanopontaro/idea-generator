import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/category.dart';
import 'package:idea_generator/classes/category_list.dart';
import 'package:idea_generator/providers.dart';

final _strictCategoryListProvider = Provider<List<Category>>((ref) {
  final categoryList = ref.watch(categoryListProvider);
  return categoryList
      .where((cat) => cat.id != CategoryList.userKeywordId)
      .toList();
});

class CategorySelectScreen extends HookConsumerWidget {
  const CategorySelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final strictCategoryList = ref.watch(_strictCategoryListProvider);
    final categoryList = ref.read(categoryListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('カテゴリーの設定')),
      body: ListView.builder(
        itemCount: strictCategoryList.length,
        itemBuilder: (_, index) {
          final category = strictCategoryList[index];
          return CheckboxListTile(
            title: Text(category.text),
            value: !category.disabled,
            onChanged: (value) {
              if (value == false && categoryList.countEnabled < 3) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: const Text('最低でもひとつは選択してください。'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }
              categoryList.edit(id: category.id, disabled: !value!);
            },
          );
        },
      ),
    );
  }
}
