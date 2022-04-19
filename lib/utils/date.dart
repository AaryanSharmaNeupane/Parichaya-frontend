String getFormattedExpiry(DateTime expiryDate) {
  final now = DateTime.now().toLocal();
  final localExpiryDate = expiryDate.toLocal();

  final days = localExpiryDate.difference(now).inDays;

  final hours = localExpiryDate.difference(now).inHours - days * 24;

  final minutes = localExpiryDate.difference(now).inMinutes - (hours * 60);

  String formattedExpiry = '';

  if (days > 0) {
    formattedExpiry = "$days day${days > 1 ? 's' : ''}";
  } else if (hours > 0) {
    formattedExpiry = '$hours hour${hours > 1 ? 's' : ''}';
  } else if (minutes > 0) {
    formattedExpiry = '$minutes minute${minutes > 1 ? 's' : ''}';
  }

  return formattedExpiry;
}
