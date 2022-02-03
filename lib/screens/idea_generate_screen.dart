import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/idea.dart';
import 'package:idea_generator/parts/word_generator.dart';
import 'package:idea_generator/providers.dart';
import 'package:idea_generator/screens/category_select_screen.dart';
import 'package:idea_generator/screens/idea_edit_screen.dart';
import 'package:idea_generator/screens/word_edit_screen.dart';
import 'package:idea_generator/palette.dart' as palette;

class IdeaGenerateScreen extends HookConsumerWidget {
  const IdeaGenerateScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final currentIdea = ref.watch(currentIdeaProvider.notifier);
    final randomWord = ref.watch(randomWordProvider);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final animation = useMemoized(
      () => Tween<double>(begin: 0, end: 1).animate(controller),
      [controller],
    );

    return Scaffold(
      backgroundColor: palette.brand,
      appBar: AppBar(),
      body: Column(
        children: [
          const Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Align(alignment: Alignment.center, child: WordGenerator()),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: IconButton(
                    icon: const Icon(Icons.format_list_bulleted),
                    color: palette.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategorySelectScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Flexible(
                  child: Ink(
                    width: 80,
                    height: 80,
                    decoration: const ShapeDecoration(
                      color: palette.orange,
                      shape: CircleBorder(),
                    ),
                    child: RotationTransition(
                      turns: animation,
                      child: IconButton(
                        icon: const Icon(Icons.loop),
                        iconSize: 40,
                        color: palette.white,
                        onPressed: () {
                          controller.forward(from: 0);
                          randomWord.refresh();
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: IconButton(
                    icon: const Icon(Icons.add_box),
                    color: palette.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WordEditScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  final keyword = ref.read(currentKeywordProvider)!;
                  final idea = Idea.blank();
                  currentIdea.state = idea.copyWith(keywordId: keyword.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const IdeaEditScreen()),
                  );
                },
                child: const Text(
                  'I love this!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
