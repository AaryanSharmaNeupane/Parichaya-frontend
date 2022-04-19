String generateLimitedLengthText(String text, int limit) {
  if (text.length > limit) {
    return text.replaceRange(limit, null, '...');
  }
  return text;
}
