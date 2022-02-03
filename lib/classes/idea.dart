import 'package:idea_generator/classes/base_item.dart';
import 'package:idea_generator/classes/tag.dart';
import 'package:idea_generator/classes/tag_list.dart';

class Idea extends BaseItem {
  final DateTime updated;
  final String title;
  final String description;
  final String themeId;
  final String keywordId;
  final List<String> tags;
  final bool image;

  Idea({
    String? id,
    required this.updated,
    required this.title,
    required this.description,
    required this.themeId,
    required this.keywordId,
    required this.tags,
    required this.image,
  }) : super(id: id);

  @override
  Idea copyWith({
    DateTime? updated,
    String? title,
    String? description,
    String? themeId,
    String? keywordId,
    List<String>? tags,
    bool? image,
  }) {
    return Idea(
      id: id,
      updated: updated ?? this.updated,
      title: title ?? this.title,
      description: description ?? this.description,
      themeId: themeId ?? this.themeId,
      keywordId: keywordId ?? this.keywordId,
      tags: [...(tags ?? this.tags)],
      image: image ?? this.image,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updated': updated.millisecondsSinceEpoch,
      'title': title,
      'description': description,
      'themeId': themeId,
      'keywordId': keywordId,
      'tags': tags,
      'image': image,
    };
  }

  factory Idea.fromMap(Map<String, dynamic> map) {
    return Idea(
      id: map['id'] as String,
      updated: DateTime.fromMillisecondsSinceEpoch(map['updated']),
      title: map['title'] as String,
      description: map['description'] as String,
      themeId: map['themeId'] as String,
      keywordId: map['keywordId'] as String,
      tags: List<String>.from(map['tags']),
      image: map['image'] as bool,
    );
  }

  factory Idea.blank() {
    return Idea(
      updated: DateTime.now(),
      title: '',
      description: '',
      themeId: '',
      keywordId: '',
      tags: [TagList.allId],
      image: false,
    );
  }

  bool hasTag(Tag tag) => tags.contains(tag.id);

  bool get isFavorite => tags.contains(TagList.favoriteId);
}
