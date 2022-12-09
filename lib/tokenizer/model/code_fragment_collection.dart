import 'package:dart_imp_interpreter/tokenizer/model/code_fragment.dart';

class CodeFragmentCollection {
  final List<CodeFragment> fragments;

  const CodeFragmentCollection({required this.fragments});
  factory CodeFragmentCollection.fromInputString({required String input}) {
    final splittedWithSpace =
        input.split(' ').fold(<String>[], (previousValue, element) {
      previousValue.addAll(element.split('\n'));
      return previousValue;
    });

    List<CodeFragment> fragments = <CodeFragment>[];
    for (final rawFragment in splittedWithSpace) {
      fragments.add(CodeFragment(rawInput: rawFragment));
    }

    return CodeFragmentCollection(
      fragments: List<CodeFragment>.unmodifiable(fragments),
    );
  }
}
