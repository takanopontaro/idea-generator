import 'dart:io';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:idea_generator/palette.dart' as palette;
import 'package:idea_generator/providers.dart';
import 'package:idea_generator/screens/idea_edit_screen.dart';

class IdeaCard extends HookConsumerWidget {
  const IdeaCard({Key? key}) : super(key: key);

  double getRandomDouble() {
    final num = Random().nextInt(21) + 10;
    return num / 10000; // 0.0020 ~ 0.0030
  }

  @override
  Widget build(context, ref) {
    final idea = ref.watch(targetIdea);
    final isShaking = ref.watch(shakingProvider);
    final shaking = ref.watch(shakingProvider.notifier);
    final ideaList = ref.watch(ideaListProvider.notifier);
    final themeList = ref.watch(themeListProvider.notifier);
    final keywordList = ref.watch(keywordListProvider.notifier);
    final currentIdea = ref.watch(currentIdeaProvider.notifier);
    final currentTheme = ref.watch(currentThemeProvider.notifier);
    final imageHandler = ref.watch(imageHandlerProvider);
    final cardController = useMemoized(() => FlipCardController(), []);
    const shadow = Shadow(color: palette.black, blurRadius: 10);

    final favoriteIcon = useMemoized(
      () => Icon(
        idea.isFavorite ? Icons.favorite : Icons.favorite_outline,
        color: idea.isFavorite ? palette.orange : palette.brand,
        size: 24,
      ),
      [idea.isFavorite],
    );

    final scaleController = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    final scaleAnimation = useMemoized(
      () => Tween<double>(begin: 1, end: 0).animate(scaleController)
        ..addStatusListener((state) {
          if (state == AnimationStatus.completed) {
            ideaList.remove(idea);
          }
        }),
      [],
    );

    final rotationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    final rotationAnimation = useMemoized(
      () {
        final factor = Random().nextInt(2) == 0 ? 1 : -1;
        final value1 = getRandomDouble() * -factor;
        final value2 = getRandomDouble() * factor;
        return TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: value1), weight: 1),
          TweenSequenceItem(
            tween: Tween(begin: value1, end: value2),
            weight: 1,
          ),
          TweenSequenceItem(tween: Tween(begin: value2, end: 0), weight: 1),
        ]).animate(rotationController);
      },
      [],
    );

    final theme = useMemoized(
      () => themeList.getById(idea.themeId).text,
      [],
    );

    final keyword = useMemoized(
      () => keywordList.getById(idea.keywordId).text,
      [],
    );

    final fetchCover = useMemoized(() async {
      if (!idea.image) {
        return null;
      }
      final path = await imageHandler.getFilePathById(idea.id);
      return BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(path)),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
        borderRadius: BorderRadius.circular(8),
      );
    }, [idea.image]);

    final coverSnapshot = useFuture(fetchCover);

    useEffect(() {
      rotationController.reset();
      if (isShaking) {
        rotationController.repeat();
      }
    }, [isShaking]);

    return ScaleTransition(
      scale: scaleAnimation,
      child: RotationTransition(
        turns: rotationAnimation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IgnorePointer(
              ignoring: isShaking,
              child: FlipCard(
                key: ValueKey(idea.id),
                controller: cardController,
                fill: Fill.fillBack,
                direction: FlipDirection.HORIZONTAL,
                front: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(0),
                  color: palette.dimBrand,
                  child: InkWell(
                    onTap: () => cardController.toggleCard(),
                    onLongPress: () => shaking.state = true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration:
                          coverSnapshot.hasData ? coverSnapshot.data : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                theme,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: palette.white,
                                  shadows: [shadow],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              size: 28,
                              color: palette.white,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              keyword,
                              style: const TextStyle(
                                fontSize: 16,
                                color: palette.white,
                                shadows: [shadow],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                back: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(0),
                  color: palette.white,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => cardController.toggleCard(),
                          onLongPress: () => shaking.state = true,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    DateFormat('yyyy/MM/dd HH:mm').format(
                                      idea.updated,
                                    ),
                                    style: const TextStyle(
                                      color: palette.orange,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    idea.title,
                                    textScaleFactor: 1.2,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    idea.description,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                currentTheme.state = theme;
                                currentIdea.state = idea.copyWith();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const IdeaEditScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                color: palette.dimGray,
                                child: const Icon(Icons.edit, size: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 1),
                          Expanded(
                            child: InkWell(
                              onTap: () => ideaList.toggleFavorite(idea.id),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                color: palette.dimGray,
                                child: favoriteIcon,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isShaking,
              child: Positioned(
                right: -4,
                top: -4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const ShapeDecoration(
                    color: palette.lightBrand,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close),
                    color: palette.white,
                    onPressed: () => scaleController.forward(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
