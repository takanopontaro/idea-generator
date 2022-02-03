import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/tag.dart';
import 'package:idea_generator/palette.dart' as palette;
import 'package:idea_generator/providers.dart';

class TagEditScreen extends HookConsumerWidget {
  const TagEditScreen({Key? key}) : super(key: key);

  void showDeleteDialog(BuildContext context, Tag tag, WidgetRef ref) {
    final tagList = ref.read(tagListProvider.notifier);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: const Text('タグを削除します。よろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              tagList.remove(tag);
              Navigator.pop(context, 'OK');
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
            const Text('タグの名前を入力してください。'),
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
    final tagList = ref.watch(tagListProvider.notifier);
    final strictTagList = ref.watch(strictTagListProvider);
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('タグの編集'),
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
                    final text = controller.text.trim();
                    if (text.isEmpty || tagList.tagExists(text)) {
                      return;
                    }
                    tagList.add(Tag(text: text));
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
        itemCount: strictTagList.length,
        itemBuilder: (_, index) {
          final tag = strictTagList[index];
          return Slidable(
            startActionPane: ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => showDeleteDialog(context, tag, ref),
                  backgroundColor: palette.red,
                  foregroundColor: palette.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  spacing: 6,
                ),
                SlidableAction(
                  onPressed: (_) {
                    controller.text = tag.text;
                    showEditDialog(
                      context,
                      controller,
                      TextButton(
                        onPressed: () {
                          final text = controller.text.trim();
                          if (text.isEmpty || tagList.tagExists(text)) {
                            return;
                          }
                          tagList.edit(id: tag.id, text: text);
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
            child: ListTile(title: Text(tag.text)),
          );
        },
      ),
    );
  }
}
