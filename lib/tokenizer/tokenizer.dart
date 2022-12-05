import 'package:dart_imp_interpreter/tokenizer/model/token.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';
import 'package:dart_imp_interpreter/tokenizer/model/tokenize_result.dart';
import 'package:dart_imp_interpreter/tokenizer/reserved_words.dart';

/// 入力文字列をトークンにして返す関数
///
/// 処理の流れ
/// 1. 空白, 改行で区切る
/// 2. 区切られた箇所で更に区切れるなら区切ってトークン化（記号が含まれるとき）
List<Token> tokenize({required String rawInput}) {
  // 空白、改行で区切る
  final inputFragments = rawInput.split(' ').fold(
    <String>[],
    (previousValue, element) {
      previousValue.addAll(element.split('\n'));
      return previousValue;
    },
  );

  // 各切れ端をトークン列に変換
  final tokens = <Token>[];
  for (final fragment in inputFragments) {
    final result = fragmentToTokens(rawInput: fragment);
    tokens.addAll(result);
  }

  return tokens;
}

/// 空白なしの文字列をトークンのリストにして返す関数
List<Token> fragmentToTokens({required String rawInput}) {
  final tokens = <Token>[];
  String untokenizedInput = rawInput;
  bool lastSuccess = false;

  for (;;) {
    lastSuccess = false;

    // もう細分化できないときはここで処置。記号を含まないフラットな文字列を想定できる。
    if (!containsReservedSymbol(stringFragment: untokenizedInput)) {
      // 予約語でない -> 識別子のパターンとマッチしたら識別子として処理して良い。
      if (!reservedWords.contains(untokenizedInput)) {
        final regExp = RegExp(TokenKind.identifier.pattern);
        final matchResult = regExp.matchAsPrefix(untokenizedInput);
        final isIdentifier = matchResult?.group(0) == untokenizedInput;
        if (isIdentifier) {
          tokens.add(
            Token(tokenKind: TokenKind.identifier, value: untokenizedInput),
          );
          untokenizedInput = '';
          lastSuccess = true;
          break;
        }
      }
      // 予約語だった場合
      bool wasReserved = false;
      for (final tokenData in TokenKind.values) {
        if (tokenData.words?.contains(untokenizedInput) ?? false) {
          tokens.add(Token(tokenKind: tokenData, value: untokenizedInput));
          untokenizedInput = '';
          lastSuccess = true;
          wasReserved = true;
          break;
        }
      }
      if (wasReserved) {
        break;
      }
    }

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

/// 渡された文字列がさらに分割可能か調べる関数
bool containsReservedSymbol({required String stringFragment}) {
  for (final symbol in reservedSymbols) {
    if (stringFragment.contains(symbol)) {
      return true;
    }
  }

  return false;
}
