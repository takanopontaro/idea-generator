import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:idea_generator/classes/idea.dart';
import 'package:idea_generator/providers.dart';
import 'package:path_provider/path_provider.dart';

enum Status { none, added, replaced, removed }

class ImageHandler {
  final Ref ref;
  final ImagePicker picker;

  Status status = Status.none;
  String ideaId = '';
  bool originallyHasImage = false;

  ImageHandler(this.ref)
      : picker = ImagePicker(),
        super();

  void init(Idea idea) {
    status = Status.none;
    ideaId = idea.id;
    originallyHasImage = idea.image;
  }

  Future<void> pickImage(ImageSource source) async {
    final file = await picker.pickImage(source: source);
    if (file != null) {
      saveTempPhoto(file);
    }
  }

  void updateIdea(bool image) {
    final idea = ref.read(currentIdeaProvider)!;
    ref.read(currentIdeaProvider.notifier).state = idea.copyWith(image: image);
  }

  Future<String> getTempFilePath() async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/$ideaId';
  }

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$ideaId';
  }

  Future<String> getFilePathById(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$id';
  }

  Future<String> getAppropriateFilePath() async {
    if (originallyHasImage && status == Status.none) {
      return await getFilePath();
    }
    if (status == Status.added || status == Status.replaced) {
      return await getTempFilePath();
    }
    return '';
  }

  Future<void> saveTempPhoto(XFile photo) async {
    final file = File(await getTempFilePath());
    final buffer = await photo.readAsBytes();
    file.writeAsBytesSync(buffer, mode: FileMode.write, flush: true);
    status = originallyHasImage ? Status.replaced : Status.added;
    updateIdea(true);
  }

  Future<void> savePhoto() async {
    final file = File(await getTempFilePath());
    file.copySync(await getFilePath());
  }

  Future<void> removeTempPhoto() async {
    final file = File(await getTempFilePath());
    file.deleteSync();
    status = originallyHasImage ? Status.removed : Status.none;
    updateIdea(false);
  }

  Future<void> removePhoto() async {
    final file = File(await getFilePath());
    file.deleteSync();
  }

  Future<void> removePhotoById(String id) async {
    final file = File(await getFilePathById(id));
    file.deleteSync();
  }

  void removePhotoTemporarily() {
    status = originallyHasImage ? Status.removed : Status.none;
    updateIdea(false);
  }

  Future<void> handleFile() async {
    switch (status) {
      case Status.removed:
        await removePhoto();
        break;
      case Status.added:
      case Status.replaced:
        await savePhoto();
        break;
      case Status.none:
        break;
    }
  }
}
