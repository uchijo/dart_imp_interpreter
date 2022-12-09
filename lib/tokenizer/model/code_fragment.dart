import 'package:dart_imp_interpreter/tokenizer/const/reserved_words.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';
import 'package:dart_imp_interpreter/tokenizer/model/tokenize_result.dart';

class CodeFragment {
  final String rawInput;

  const CodeFragment({required this.rawInput});

  List<Token> toTokenList() {
    final tokens = <Token>[];
    String untokenizedInput = rawInput;
    bool lastSuccess = false;

    // もう細分化できないときはここで処置。記号を含まないフラットな文字列を想定できる。
    if (!isDevidable()) {
      if (isReservedWord()) {
        // 予約語だった場合
        return [Token.asReservedWord(input: untokenizedInput)];
      }

      if (isIntegerLiteral()) {
        return [Token.asInteger(input: untokenizedInput)];
      }

      return [Token.asIdentifier(input: untokenizedInput)];
    }

    for (;;) {
      lastSuccess = false;

      // 各トークンに関してループ回す
      // トークナイズできたらループ抜ける
      // 識別子はほぼ全てにマッチするので一番最後に処理しないとダメ
      for (final kind in (TokenKind.values
          .where((element) => element != TokenKind.identifier)
          .toList())
        ..add(TokenKind.identifier)) {
        final result = getToken(input: untokenizedInput, targetKind: kind);
        untokenizedInput = result.processedString;
        if (result.success) {
          tokens.add(result.token!);
          lastSuccess = true;
          break;
        }
      }

      // トークナイズに成功したのならループ続ける。
      // そうでなければトークン化できないものが発生したか全部トークン化できたということ
      if (!lastSuccess) {
        break;
      }
    }

    // untokenizedInputが空文字じゃないのにここにたどり着いているのはトークナイズに失敗したということ。
    if (untokenizedInput.isNotEmpty) {
      throw Exception('トークン化に失敗');
    }

    return tokens;
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

  /// 空白なしの文字列からトークンを1個だけ切り出そうとする関数
  TokenizeResult getToken({
    required String input,
    required TokenKind targetKind,
  }) {
    final matched = RegExp(targetKind.pattern).matchAsPrefix(input);

    // 見つからない場合
    if (matched == null) {
      return TokenizeResult(success: false, processedString: input);
    }

    // 見つかったら
    final removeMatchedInput = input.substring(matched.group(0)?.length ?? 0);
    return TokenizeResult(
      success: true,
      processedString: removeMatchedInput.trimLeft(), // 左端の空白を消す
      token: Token(tokenKind: targetKind, value: matched.group(0) ?? ''),
    );
  }
}
