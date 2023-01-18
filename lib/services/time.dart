String monthText(int month) {
  return [
    '',
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre'
  ][month];
}

String timeElapsed(DateTime dateTime) {
  DateTime now = DateTime.now();

  Duration difference = now.difference(dateTime);

  if (difference.inDays > 7) {
    if (dateTime.year < now.year) {
      return 'Le ${dateTime.day} ${monthText(dateTime.month)} ${dateTime.year}';
    } else {
      return 'Le ${dateTime.day} ${monthText(dateTime.month)}';
    }
  } else if (difference.inDays > 0) {
    return 'Il y a ${difference.inDays} jours';
  } else if (difference.inHours > 0) {
    return 'Il y a ${difference.inHours} heures';
  } else {
    return 'Il y a ${difference.inMinutes} minutes';
  }
}
