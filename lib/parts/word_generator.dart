import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/providers.dart';
import 'package:idea_generator/palette.dart' as palette;

class WordGenerator extends HookConsumerWidget {
  const WordGenerator({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    const strutStyle = StrutStyle(fontSize: 24, height: 1.7);
    final currentTheme = ref.watch(currentThemeProvider);
    final currentKeyword = ref.watch(currentKeywordProvider);
    final nextKeyword = ref.watch(nextKeywordProvider);
    final animating = ref.watch(animatingProvider);
    final duration = useMemoized(() => animating ? 300 : 0, [animating]);
    final radians = useMemoized(() => animating ? -1.5 * pi : 0.0, [animating]);

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentTheme,
            style: const TextStyle(color: palette.white),
            strutStyle: strutStyle,
          ),
          const SizedBox(height: 18),
          AnimatedContainer(
            transformAlignment: Alignment.center,
            transform: Matrix4.rotationZ(radians),
            duration: Duration(milliseconds: duration),
            child: const Icon(Icons.close, size: 40, color: palette.dimWhite),
          ),
          const SizedBox(height: 8),
          ClipRect(
            child: Align(
              heightFactor: 1 / 3,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  AnimatedAlign(
                    heightFactor: 3,
                    alignment:
                        animating ? Alignment.center : Alignment.topCenter,
                    duration: Duration(milliseconds: duration),
                    child: Text(
                      nextKeyword?.text ?? '',
                      style: const TextStyle(color: palette.orange),
                      strutStyle: strutStyle,
                    ),
                    onEnd: () {
                      if (!animating) {
                        return;
                      }
                      ref.read(currentKeywordProvider.notifier).state =
                          nextKeyword;
                      ref.read(nextKeywordProvider.notifier).state = null;
                      ref.read(animatingProvider.notifier).state = false;
                    },
                  ),
                  AnimatedAlign(
                    heightFactor: 3,
                    alignment:
                        animating ? Alignment.bottomCenter : Alignment.center,
                    duration: Duration(milliseconds: duration),
                    child: Text(
                      currentKeyword?.text ?? '',
                      style: const TextStyle(color: palette.orange),
                      strutStyle: strutStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
