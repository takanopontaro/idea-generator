import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/parts/current_filter_tag_list.dart';
import 'package:idea_generator/parts/drawer_body.dart';
import 'package:idea_generator/parts/idea_card_list.dart';
import 'package:idea_generator/parts/search_field.dart';
import 'package:idea_generator/providers.dart';
import 'package:idea_generator/screens/tag_edit_screen.dart';
import 'package:idea_generator/screens/tag_select_screen.dart';
import 'package:idea_generator/screens/theme_input_screen.dart';
import 'package:idea_generator/palette.dart' as palette;

class HomePageScreen extends HookConsumerWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final currentTheme = ref.watch(currentThemeProvider.notifier);
    final shaking = ref.watch(shakingProvider.notifier);

    return GestureDetector(
      onTap: () => shaking.state = false,
      child: Scaffold(
        backgroundColor: palette.brand,
        appBar: AppBar(
          title: InkWell(
            onTap: () {
              shaking.state = false;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TagSelectScreen()),
              );
            },
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: kToolbarHeight,
              child: const CurrentFilterTagList(),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.local_offer),
              onPressed: () {
                shaking.state = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TagEditScreen()),
                );
              },
            ),
          ],
        ),
        drawer: const DrawerBody(),
        onDrawerChanged: (open) => shaking.state = false,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SearchField(provider: filterTextProvider),
              const Flexible(child: IdeaCardList()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            shaking.state = false;
            currentTheme.state = '';
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemeInputScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
