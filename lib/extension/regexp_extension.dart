extension RegExpExtension on RegExp {
  bool matchAsWhole(String other) {
    final result = firstMatch(other);
    if (result == null) {
      return false;
    }
    return result.group(0) == other;
  }
}
