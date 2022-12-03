import 'package:dart_imp_interpreter/tokenizer/tokenizer.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    print('invalid number of arguments');
    return;
  }

  print('argument 0: ${arguments[0]}');
  final tokenized = tokenize(rawInput: arguments[0]);
}
