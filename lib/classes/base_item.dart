class BaseItem {
  final String id;

  BaseItem({String? id})
      : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  BaseItem copyWith() {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
