import 'package:dart_imp_interpreter/tokenizer/model/token.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';
import 'package:dart_imp_interpreter/tokenizer/model/tokenize_result.dart';

/// 入力文字列をトークンにして返す関数
/// 
/// 処理の流れ
/// 1. 空白, 改行で区切る
/// 2. 区切られた箇所で更に区切れるなら区切る（記号が含まれるとき）
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

  // untokenizedInputが空文字じゃないのにここにたどり着いているのはトークナイズに失敗したということ。
  if (untokenizedInput.isEmpty) {
    throw Exception('トークン化に失敗');
  }

  return tokens;
}

/// 文字列からトークンを切り出そうとする関数
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
    processedString: removeMatchedInput.trimLeft(), // 左端の空白を消す
    token: Token(tokenKind: targetKind, value: matched.group(0) ?? ''),
  );
}
