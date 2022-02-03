import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/providers.dart';

class TagSelectScreen extends HookConsumerWidget {
  const TagSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final tagList = ref.watch(tagListProvider);
    final filterTagList = ref.watch(filterTagListProvider.notifier);
    final _ = ref.watch(filterTagListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('タグで絞り込む')),
      body: ListView.builder(
        itemCount: tagList.length,
        itemBuilder: (_, index) {
          final tag = tagList[index];
          return CheckboxListTile(
            title: Text(tag.text),
            value: filterTagList.exists(tag.id),
            onChanged: (value) {
              if (value!) {
                filterTagList.add(tag);
                return;
              }
              if (filterTagList.countEnabled < 2) {
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
              filterTagList.remove(tag);
            },
          );
        },
      ),
    );
  }
}
