enum TokenKind {
  iop(
    ['+', '-'],
    r'[+-]',
  ),
  bop(
    ['=', '<', '>'],
    r'[=><]',
  ),
  integer(
    null,
    r'\d+',
  ),
  boolean(
    ['true', 'false'],
    r'(true)|(false)',
  ),
  identifier(
    null,
    r'[a-zA-Z][0-9a-zA-Z]*',
  ),
  control(
    [':=', ';', 'skip', 'if', 'then', 'else', 'while', 'do'],
    r'(:=)|(;)|(skip)|(if)|(then)|(else)|(while)|(do)',
  );

  const TokenKind(this.words, this.pattern);

  final List<String>? words;
  final String pattern;
}
