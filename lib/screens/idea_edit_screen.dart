import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:idea_generator/providers.dart';
import 'package:idea_generator/screens/home_page_screen.dart';
import 'package:idea_generator/screens/photo_view_screen.dart';
import 'package:idea_generator/screens/tag_attach_screen.dart';
import 'package:idea_generator/palette.dart' as palette;

class IdeaEditScreen extends HookConsumerWidget {
  const IdeaEditScreen({Key? key}) : super(key: key);

  void pickImage(BuildContext context, WidgetRef ref) {
    final imageHandler = ref.read(imageHandlerProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: palette.white,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('カメラ'),
              tileColor: palette.white,
              onTap: () {
                Navigator.pop(context);
                imageHandler.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_emoticon),
              title: const Text('ギャラリー'),
              tileColor: palette.white,
              onTap: () {
                Navigator.pop(context);
                imageHandler.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget tagWidget(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: palette.darkGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(text, style: const TextStyle(color: palette.white)),
        ),
      ],
    );
  }

  @override
  Widget build(context, ref) {
    final idea = ref.watch(currentIdeaProvider);

    if (idea == null) {
      throw Exception('No idea');
    }

    final ideaList = ref.watch(ideaListProvider.notifier);
    final themeList = ref.watch(themeListProvider.notifier);
    final keywordList = ref.watch(keywordListProvider.notifier);
    final tagList = ref.watch(tagListProvider.notifier);
    final currentIdea = ref.watch(currentIdeaProvider.notifier);
    final imageHandler = ref.watch(imageHandlerProvider);
    final theme = ref.watch(currentThemeProvider);
    final titleController = useTextEditingController(text: idea.title);
    final descController = useTextEditingController(text: idea.description);

    final keyword = useMemoized(
      () => keywordList.getById(idea.keywordId).text,
      [],
    );

    final tags = useMemoized(() {
      final widgets = idea.tags.fold<List<Widget>>([], (list, tagId) {
        if (!tagList.isSpecialTag(tagId)) {
          final tag = tagWidget(tagList.getById(tagId).text);
          list.add(tag);
        }
        return list;
      });
      if (widgets.length > 10) {
        widgets.length = 10;
        widgets.add(const Text('…'));
      }
      return widgets;
    }, [idea.tags]);

    useEffect(() {
      imageHandler.init(idea);
    }, []);

    final image = useMemoized(() {
      if (!idea.image) {
        return IconButton(
          onPressed: () => pickImage(context, ref),
          icon: const Icon(Icons.image),
        );
      }
      return FutureBuilder<String>(
        future: imageHandler.getAppropriateFilePath(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Container(color: palette.gray, width: 24, height: 24);
          }
          return IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PhotoViewScreen()),
              );
            },
            icon: Image.file(
              File(snapshot.data!),
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }, [idea]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('アイディアの編集'),
        actions: [
          TextButton(
            onPressed: () {
              if (idea.title.isEmpty || idea.description.isEmpty) {
                return;
              }
              if (ideaList.exists(idea.id)) {
                ideaList.edit(
                  id: idea.id,
                  updated: DateTime.now(),
                  title: idea.title,
                  description: idea.description,
                  tags: idea.tags,
                  image: idea.image,
                );
              } else {
                final themeId = themeList.saveOrCreate(theme);
                final newIdea = idea.copyWith(
                  updated: DateTime.now(),
                  themeId: themeId,
                );
                ideaList.add(newIdea);
              }
              imageHandler.handleFile();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePageScreen()),
                (_) => false,
              );
            },
            child: const Text(
              'Save',
              style: TextStyle(color: palette.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: palette.dimBrand,
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: DefaultTextStyle(
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: palette.white, fontSize: 16),
                child: Column(children: [Text(theme), Text(keyword)]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        suffixIcon: image,
                      ),
                      onChanged: (value) {
                        currentIdea.state = idea.copyWith(title: value.trim());
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: descController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) {
                          currentIdea.state =
                              idea.copyWith(description: value.trim());
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TagAttachScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.add, size: 18),
                              Icon(Icons.local_offer)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tags,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
