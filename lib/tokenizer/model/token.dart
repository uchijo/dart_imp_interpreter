import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';

class Token {
  Token({required this.tokenKind, required this.value});

  final TokenKind tokenKind;
  final String value;
}
