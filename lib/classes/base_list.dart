import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/base_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseList<T extends BaseItem> extends StateNotifier<List<T>> {
  final Ref ref;
  final String key;

  BaseList(this.ref, this.key) : super([]);

  T getById(String id) {
    return state.firstWhere((d) => d.id == id);
  }

  T clone(String id) {
    return getById(id).copyWith() as T;
  }

  T fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  bool get isNotEmpty => state.isNotEmpty;

  bool get isEmpty => state.isEmpty;

  bool exists(String id) {
    return state.indexWhere((item) => item.id == id) != -1;
  }

  bool add(T item) {
    if (exists(item.id)) {
      return false;
    }
    state = [...state, item];
    write();
    return true;
  }

  bool addAll(List<T> items) {
    state = state + items;
    write();
    return true;
  }

  bool remove(T item) {
    state = state.where((itm) => itm.id != item.id).toList();
    write();
    return true;
  }

  void clear() {
    state = [];
    write();
  }

  Future<bool> read() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) {
      return false;
    }
    final list = List<Map<String, dynamic>>.from(jsonDecode(data));
    state = list.map((map) => fromMap(map)).toList();
    return true;
  }

  Future<void> write() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(state));
  }

  Future<void> load(String jsonPath) async {
    final jsonStr = await rootBundle.loadString(jsonPath);
    final list = jsonDecode(jsonStr) as List;
    final List<T> items = [];
    for (final map in list) {
      items.add(fromMap(map));
    }
    addAll(items);
  }
}
