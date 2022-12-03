import 'package:dart_imp_interpreter/tokenizer/model/token.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';
import 'package:dart_imp_interpreter/tokenizer/model/tokenize_result.dart';

List<Token> tokenize({required String rawInput}) {
  final tokens = <Token>[];
  String untokenizedInput = rawInput;
  bool lastSuccess = false;

  for (;;) {
    lastSuccess = false;
    // 各トークンに関してループ回す
    // トークナイズできたらループ抜ける
    for (final kind in TokenKind.values) {
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

  print('');
  print('result:');
  for (final token in tokens) {
    print('$token');
  }

  return [];
}

/// 文字列から整数トークンを切り出そうとする関数
TokenizeResult getToken({
  required String input,
  required TokenKind targetKind,
}) {
  final matched = RegExp(targetKind.pattern).matchAsPrefix(input);

  // 見つからない場合
  if (matched == null) {
    print('no $targetKind match for input');
    return TokenizeResult(success: false, processedString: input);
  }

  // 見つかったら
  print('matched $targetKind : ${matched.group(0)}');
  final removeMatchedInput = input.substring(matched.group(0)?.length ?? 0);
  return TokenizeResult(
    success: true,
    processedString: removeMatchedInput.trimLeft(),
    token: Token(tokenKind: targetKind, value: matched.group(0) ?? ''),
  );
}
