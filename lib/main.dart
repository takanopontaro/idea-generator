import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/classes/data_store.dart';
import 'package:idea_generator/screens/home_page_screen.dart';
import 'package:idea_generator/palette.dart' as palette;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData createTheme() {
    final theme = ThemeData();

    return theme.copyWith(
      disabledColor: palette.dimBrand,
      hintColor: palette.dimWhite,
      scaffoldBackgroundColor: palette.canvas,
      colorScheme: theme.colorScheme.copyWith(
        primary: palette.orange,
        secondary: palette.orange,
      ),
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: palette.brand,
        elevation: 0,
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        backgroundColor: palette.orange,
        foregroundColor: palette.white,
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        tileColor: palette.canvas,
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        iconColor: palette.inputIcon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: palette.dimWhite),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: palette.dimBrand),
        ),
      ),
      checkboxTheme: theme.checkboxTheme.copyWith(
        fillColor: palette.checkbox,
      ),
      drawerTheme: theme.drawerTheme.copyWith(
        backgroundColor: palette.canvas,
      ),
    );
  }

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idea Generator',
      theme: createTheme(),
      home: const Home(),
    );
  }
}

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    final dataStore = useMemoized(() => DataStore(ref), []);

    return FutureBuilder<bool>(
      // If you want dummy data for quick checking of this software, this method might be helpful.
      // future: dataStore.dummy(),
      future: dataStore.read(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return const HomePageScreen();
      },
    );
  }
}
