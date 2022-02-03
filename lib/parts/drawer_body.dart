import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/idea.dart';
import 'package:idea_generator/providers.dart';
import 'package:idea_generator/palette.dart' as palette;
import 'package:idea_generator/screens/idea_edit_screen.dart';

final _favoriteIdeaListProvider = Provider<List<Idea>>((ref) {
  final ideaList = ref.watch(ideaListProvider);
  return ideaList.where((idea) => idea.isFavorite).toList();
});

class DrawerBody extends HookConsumerWidget {
  const DrawerBody({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final favoriteIdeaList = ref.watch(_favoriteIdeaListProvider);
    final ideaList = ref.watch(ideaListProvider.notifier);
    final themeList = ref.watch(themeListProvider.notifier);
    final currentIdea = ref.watch(currentIdeaProvider.notifier);
    final currentTheme = ref.watch(currentThemeProvider.notifier);

    return Drawer(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            title: Text('お気に入り'),
            centerTitle: false,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final idea = favoriteIdeaList[index];
                final theme = themeList.getById(idea.themeId).text;
                return Dismissible(
                  background: Container(color: palette.red),
                  key: ValueKey(idea.id),
                  onDismissed: (_) => ideaList.toggleFavorite(idea.id),
                  child: ListTile(
                    title: Text(idea.title),
                    style: ListTileStyle.list,
                    onTap: () {
                      currentTheme.state = theme;
                      currentIdea.state = idea.copyWith();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const IdeaEditScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: favoriteIdeaList.length,
            ),
          ),
        ],
      ),
    );
  }
}
