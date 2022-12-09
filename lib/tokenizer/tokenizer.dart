import 'package:dart_imp_interpreter/tokenizer/model/code_fragment_collection.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token.dart';

/// 入力文字列をトークンにして返す関数
///
/// 処理の流れ
/// 1. 空白, 改行で区切る
/// 2. 区切られた箇所で更に区切れるなら区切ってトークン化（記号が含まれるとき）
List<Token> tokenize({required String rawInput}) {
  // 空白、改行で区切る
  final inputFragments = CodeFragmentCollection.fromInputString(
    input: rawInput,
  );

  // 各切れ端をトークン列に変換
  final tokens = <Token>[];
  for (final fragment in inputFragments.fragments) {
    final result = fragment.toTokenList();
    tokens.addAll(result);
  }

  return tokens;
}
