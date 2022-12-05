import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';

final reservedWords = TokenKind.values.fold(
  <String>[],
  (previousValue, element) {
    previousValue.addAll(element.words ?? []);
    return previousValue;
  },
);

final _nonReservedSymbolPattern = RegExp(r'[a-zA-Z0-9]+');

final reservedSymbols = TokenKind.values.fold(
  <String>[],
  (previousValue, element) {
    if (element.words == null) {
      return previousValue;
    }

    for (final word in element.words!) {
      // 英数字のみ含むものは予約語に含まれる記号じゃない
      if (_nonReservedSymbolPattern.hasMatch(word)) {
        continue;
      }
      previousValue.add(word);
    }

    return previousValue;
  },
);
