import 'package:dart_imp_interpreter/parser/parser.dart';
import 'package:test/test.dart';

void main() {
  test('空のトークン列を受け取ったら空の構文解析結果を返す', () {
    final result = parse([]);
    expect(result, []);
  });
}
