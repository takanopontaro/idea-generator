import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/base_list.dart';
import 'package:idea_generator/classes/theme.dart';

class ThemeList extends BaseList<Theme> {
  ThemeList(Ref ref) : super(ref, 'theme');

  @override
  Theme fromMap(Map<String, dynamic> map) => Theme.fromMap(map);

  String saveOrCreate(String text) {
    final index = state.indexWhere((theme) => theme.text == text);
    Theme theme;
    if (index == -1) {
      theme = Theme(text: text);
      add(theme);
    } else {
      theme = state[index];
    }
    return theme.id;
  }
}
