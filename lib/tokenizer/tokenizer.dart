import 'package:dart_imp_interpreter/tokenizer/model/token.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';
import 'package:dart_imp_interpreter/tokenizer/model/tokenize_result.dart';

List<Token> tokenize({required String rawInput}) {
  final result = getToken(input: rawInput, targetKind: TokenKind.boolean);

  print('');
  print(
    'result. processedString: ${result.processedString}, token: ${result.token}',
  );

  return [];
}

/// 文字列から整数トークンを切り出そうとする関数
TokenizeResult getToken({
  required String input,
  required TokenKind targetKind,
}) {
  final matched = RegExp(targetKind.pattern).firstMatch(input);

  // 見つからない場合
  if (matched == null) {
    print('no match for input');
    return TokenizeResult(success: false, processedString: input);
  }

  // 見つかったら
  print('matched : ${matched.group(0)}');
  return TokenizeResult(
    success: true,
    processedString: input.substring(matched.group(0)?.length ?? 0),
    token: Token(tokenKind: targetKind, value: matched.group(0) ?? ''),
  );
}
