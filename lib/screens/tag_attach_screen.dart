import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/providers.dart';

class TagAttachScreen extends HookConsumerWidget {
  const TagAttachScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final idea = ref.watch(currentIdeaProvider);

    if (idea == null) {
      throw Exception('No idea');
    }

    final currentIdea = ref.watch(currentIdeaProvider.notifier);
    final strictTagList = ref.watch(strictTagListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('タグ付け')),
      body: ListView.builder(
        itemCount: strictTagList.length,
        itemBuilder: (_, index) {
          final tag = strictTagList[index];
          return CheckboxListTile(
            title: Text(tag.text),
            value: idea.hasTag(tag),
            onChanged: (value) {
              if (value!) {
                idea.tags.add(tag.id);
              } else {
                idea.tags.remove(tag.id);
              }
              currentIdea.state = idea.copyWith();
            },
          );
        },
      ),
    );
  }
}
