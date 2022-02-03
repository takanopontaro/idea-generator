import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/providers.dart';
import 'package:photo_view/photo_view.dart';
import 'package:idea_generator/palette.dart' as palette;

class PhotoViewScreen extends HookConsumerWidget {
  const PhotoViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final imageHandler = ref.watch(imageHandlerProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              imageHandler.removePhotoTemporarily();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: imageHandler.getAppropriateFilePath(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return PhotoView(
            imageProvider: FileImage(File(snapshot.data!)),
            backgroundDecoration: const BoxDecoration(color: palette.brand),
          );
        },
      ),
    );
  }
}
