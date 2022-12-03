import 'package:dart_imp_interpreter/tokenizer/model/token.dart';

/// トークン化を試みた結果を入れるクラス
///
/// [processedString] トークン化を試みた結果残った処理対象の文字列
/// [success] トークン化に成功したらtrue
/// [token] 得られたトークン
class TokenizeResult {
  TokenizeResult({
    required this.processedString,
    required this.success,
    this.token,
  }) {
    // 成功していない場合はチェックする箇所は存在しない。
    if (!success) {
      return;
    }

    assert(token != null, 'tokenize was successful, but token is null.');
  }

  final bool success;
  final Token? token;
  final String processedString;
}
