enum TokenKind {
  iop(['+', '-']),
  bop(['=', '<', '>']),
  integer(null),
  boolean(['true', 'false']),
  variable(null),
  control([':=', ';', 'skip', 'if', 'then', 'else', 'while', 'do']);

  const TokenKind(this.words);

  final List<String>? words;
}
