import 'package:dart_imp_interpreter/tokenizer/const/reserved_words.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';

class CodeFragment {
  final String rawInput;

  const CodeFragment({required this.rawInput});

  /// トークンのリストを作る関数
  ///
  /// 空白、改行は取り除いている。
  /// よってここでは、記号を含む予約語だったら分割、そうじゃなかったら放置みたいな感じで良い。
  List<Token> toTokenList() {
    // 空文字だったら空のリストを返す
    if (rawInput == '') {
      return [];
    }

    // もう細分化できないときはここで処置。記号を含まないフラットな文字列を想定できる。
    if (!isDevidable()) {
      if (isReservedWord()) {
        // 予約語だった場合
        return [Token.asReservedWord(input: rawInput)];
      }

      if (isIntegerLiteral()) {
        return [Token.asInteger(input: rawInput)];
      }

      return [Token.asIdentifier(input: rawInput)];
    }

    return splitReserved();
  }

  /// このCodeFragmentが予約語であるかどうか
  bool isReservedWord() {
    for (final word in reservedWords) {
      if (rawInput == word) {
        return true;
      }
    }

    return false;
  }

  // このCodeFragmentはさらに分割できるか
  // 分割可能かどうか：CodeFragmentに記号のみで構成される予約語が含まれるか否か
  bool isDevidable() {
    for (final symbol in reservedSymbols) {
      if (rawInput.contains(symbol)) {
        return true;
      }
    }

    return false;
  }

  // このCodeFragmentが整数リテラルかどうか
  bool isIntegerLiteral() {
    final matchResult = RegExp(TokenKind.integer.pattern).firstMatch(rawInput);
    if (matchResult == null) {
      return false;
    }

    return matchResult.group(0) == rawInput;
  }

  /// 記号で構成される予約語を含む場合に、適切に分割する関数
  List<Token> splitReserved() {
    final tokens = <Token>[];
    var processingInput = rawInput;
    for (final symbol in reservedSymbols) {
      final symbolIndex = rawInput.indexOf(symbol);
      if (symbolIndex == -1) {
        continue;
      }

      // 記号より前部分の処理
      final beforeRawInput = processingInput.substring(0, symbolIndex);
      print('before: $beforeRawInput');
      final beforeSymbolFragment = CodeFragment(rawInput: beforeRawInput);
      tokens.addAll(beforeSymbolFragment.toTokenList());
      processingInput = processingInput.substring(beforeRawInput.length);

      // 記号自体の処理
      tokens.add(Token.asReservedWord(input: symbol));
      processingInput = processingInput.substring(symbol.length);
      print('after: $processingInput');

      // 記号より後ろ部分の処理
      final afterSymbolFragment = CodeFragment(rawInput: processingInput);
      tokens.addAll(afterSymbolFragment.toTokenList());

      break;
    }

    return tokens;
  }
}
