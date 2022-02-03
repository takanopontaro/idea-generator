import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:idea_generator/palette.dart' as palette;
import 'package:idea_generator/providers.dart';

class SearchField extends HookConsumerWidget {
  final StateProvider<String> provider;

  const SearchField({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(context, ref) {
    final shaking = ref.watch(shakingProvider.notifier);
    final controller = useTextEditingController();
    final focusNode = useFocusNode();

    useEffect(() {
      final notifier = ref.read(provider.notifier);
      controller.addListener(() => notifier.state = controller.text.trim());
      focusNode.addListener(() => shaking.state = false);
    }, []);

    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: palette.white),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          onPressed: () => controller.clear(),
          icon: const Icon(Icons.clear),
        ),
        hintText: 'Enter a filter text',
      ),
    );
  }
}
