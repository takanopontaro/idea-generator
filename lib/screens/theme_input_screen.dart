import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/providers.dart';
import 'package:idea_generator/screens/idea_generate_screen.dart';

class ThemeInputScreen extends HookConsumerWidget {
  const ThemeInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final currentTheme = ref.watch(currentThemeProvider.notifier);
    final randomWord = ref.watch(randomWordProvider);
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('テーマの入力')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => controller.clear(),
                    icon: const Icon(Icons.clear),
                  ),
                  hintText: 'Enter a theme',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 32),
              child: TextButton(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) {
                    return;
                  }
                  currentTheme.state = text;
                  randomWord.setCurrent();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IdeaGenerateScreen(),
                    ),
                  );
                },
                child: const Text('OK', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
