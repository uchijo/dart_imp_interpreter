import 'package:dart_imp_interpreter/tokenizer/const/reserved_words.dart';
import 'package:dart_imp_interpreter/tokenizer/tokenizer.dart';

void main(List<String> arguments) {
  print('reserved symbols: $reservedSymbols');
  print('reserved words: $reservedWords');

  if (arguments.length != 1) {
    print('invalid number of arguments.');
    return;
  }
  final input = arguments[0];
  print('input: $input\n');

  final result = tokenize(rawInput: input);
  print('result:');
  for (final token in result) {
    print(token);
  }
}
