import 'package:dart_imp_interpreter/extension/regexp_extension.dart';
import 'package:dart_imp_interpreter/tokenizer/const/reserved_words.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';

class Token {
  Token({required this.tokenKind, required this.value});

  final TokenKind tokenKind;
  final String value;

  factory Token.asReservedWord({required String input}) {
    for (final tokenData in TokenKind.values) {
      if (tokenData.words?.contains(input) ?? false) {
        return Token(tokenKind: tokenData, value: input);
      }
    }

    throw Exception(
      'Token.asReservedWord used on non reserved word; input was \'$input\'',
    );
  }

  factory Token.asIdentifier({required String input}) {
    // 識別子の条件を満たしているか一応確認する。
    final regExp = RegExp(TokenKind.identifier.pattern);
    final isIdentifier = regExp.matchAsWhole(input);
    if (!isIdentifier) {
      throw Exception(
        'Token.asIdentifier used on non identifier word; input was \'$input\'',
      );
    }

    return Token(
      tokenKind: TokenKind.identifier,
      value: input,
    );
  }

  factory Token.asInteger({required String input}) {
    // 整数リテラルの条件を満たしているか一応確認する。
    final regExp = RegExp(TokenKind.integer.pattern);
    final isIdentifier = regExp.matchAsWhole(input);
    if (!isIdentifier) {
      throw Exception(
        'Token.asIdentifier used on non identifier word; input was \'$input\'',
      );
    }

    return Token(
      tokenKind: TokenKind.integer,
      value: input,
    );
  }

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
