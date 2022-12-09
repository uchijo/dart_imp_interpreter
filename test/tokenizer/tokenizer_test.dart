import 'package:dart_imp_interpreter/tokenizer/model/token.dart';
import 'package:dart_imp_interpreter/tokenizer/model/token_kind.dart';
import 'package:dart_imp_interpreter/tokenizer/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  test(
    'トークンが同じかどうか判別できる',
    () {
      final tokenA = Token(tokenKind: TokenKind.integer, value: '1');
      final tokenB = Token(tokenKind: TokenKind.integer, value: '1');
      expect(tokenA, tokenB);
    },
  );
  test(
    '別トークンが渡されたら別物として判断する',
    () {
      final tokenA = Token(tokenKind: TokenKind.integer, value: '1');
      final tokenB = Token(tokenKind: TokenKind.integer, value: '2');
      expect(tokenA == tokenB, false);
    },
  );
  test(
    '空白なしの足し算引き算を正しくパースできる',
    () {
      final input = '1+2+3-4-5';
      final result = tokenize(rawInput: input);
      final expected = [
        Token(tokenKind: TokenKind.integer, value: '1'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '2'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '3'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '4'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '5'),
      ];
      expect(result, expected);
    },
  );
  test(
    '連続する算術演算をパース可能',
    () {
      final input = '1+++++2+3---4-5';
      final result = tokenize(rawInput: input);
      final expected = [
        Token(tokenKind: TokenKind.integer, value: '1'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '2'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '3'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '4'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '5'),
      ];
      expect(result, expected);
    },
  );
  test(
    '空白ありの算術演算をパース可能',
    () {
      final input = '1 + 2 + 3 - 4 - 5';
      final result = tokenize(rawInput: input);
      final expected = [
        Token(tokenKind: TokenKind.integer, value: '1'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '2'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '3'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '4'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '5'),
      ];
      expect(result, expected);
    },
  );
  test(
    '中途半端に空白ありの算術演算をパース可能',
    () {
      final input = '1+ 2 +3 - 4-5';
      final result = tokenize(rawInput: input);
      final expected = [
        Token(tokenKind: TokenKind.integer, value: '1'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '2'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.integer, value: '3'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '4'),
        Token(tokenKind: TokenKind.iop, value: '-'),
        Token(tokenKind: TokenKind.integer, value: '5'),
      ];
      expect(result, expected);
    },
  );

  test(
    '予約語、識別子を正しく識別可能',
    () {
      final input = 'if hoge else fuga do piyo while then ;;+-';
      final result = tokenize(rawInput: input);
      final expected = [
        Token(tokenKind: TokenKind.control, value: 'if'),
        Token(tokenKind: TokenKind.identifier, value: 'hoge'),
        Token(tokenKind: TokenKind.control, value: 'else'),
        Token(tokenKind: TokenKind.identifier, value: 'fuga'),
        Token(tokenKind: TokenKind.control, value: 'do'),
        Token(tokenKind: TokenKind.identifier, value: 'piyo'),
        Token(tokenKind: TokenKind.control, value: 'while'),
        Token(tokenKind: TokenKind.control, value: 'then'),
        Token(tokenKind: TokenKind.control, value: ';'),
        Token(tokenKind: TokenKind.control, value: ';'),
        Token(tokenKind: TokenKind.iop, value: '+'),
        Token(tokenKind: TokenKind.iop, value: '-'),
      ];
      expect(result, expected);
    },
  );
  test(
    '空白があったりなかったりする場合に予約語、識別子を正しく識別可能',
    () {
      final input = 'if;hoge elsefuga do;piyowhile then';
      final result = tokenize(rawInput: input);
      final expected = [
        Token(tokenKind: TokenKind.control, value: 'if'),
        Token(tokenKind: TokenKind.control, value: ';'),
        Token(tokenKind: TokenKind.identifier, value: 'hoge'),
        Token(tokenKind: TokenKind.identifier, value: 'elsefuga'),
        Token(tokenKind: TokenKind.control, value: 'do'),
        Token(tokenKind: TokenKind.control, value: ';'),
        Token(tokenKind: TokenKind.identifier, value: 'piyowhile'),
        Token(tokenKind: TokenKind.control, value: 'then'),
      ];
      expect(result, expected);
    },
  );
  test(
    '空白があったりなかったりする場合に予約語、識別子を正しく識別可能 その2',
    () {
      final input = 'if;ifhoge';
      final result = tokenize(rawInput: input);
      final expected = [
        Token(tokenKind: TokenKind.control, value: 'if'),
        Token(tokenKind: TokenKind.control, value: ';'),
        Token(tokenKind: TokenKind.identifier, value: 'ifhoge'),
      ];
      expect(result, expected);
    },
  );
}
