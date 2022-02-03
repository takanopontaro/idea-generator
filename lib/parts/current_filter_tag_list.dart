import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/providers.dart';

class CurrentFilterTagList extends HookConsumerWidget {
  const CurrentFilterTagList({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final filterTagList = ref.watch(filterTagListProvider);

    final text = useMemoized(
      () => filterTagList.map((tag) => tag.text).join('、'),
      [filterTagList],
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 5),
        const Icon(Icons.filter_alt),
      ],
    );
  }
}
