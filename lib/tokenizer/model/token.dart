import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';

class Token {
  Token({required this.tokenKind, required this.value});

  final TokenKind tokenKind;
  final String value;

  @override
  String toString() {
    return 'Token(kind: $tokenKind, value: $value)';
  }

  // e.g. https://www.youtube.com/watch?v=DCKaFaU4jdk
  @override
  int get hashCode => Object.hash(tokenKind.hashCode, value.hashCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Token &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode);
}
