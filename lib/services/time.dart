String monthText(int month) {
  return [
    '',
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'november',
    'december'
  ][month];
}

String _plural(String word, int amount) {
  return '$amount $word${amount != 1 ? 's' : ''} ago';
}

String timeElapsed(DateTime dateTime) {
  DateTime now = DateTime.now();

  Duration difference = now.difference(dateTime);

  if (difference.inDays > 7) {
    if (dateTime.year < now.year) {
      return '${dateTime.day}${dateTime.day == 1 ? 'st' : 'th'} ${monthText(dateTime.month)} ${dateTime.year}';
    } else {
      return 'Le ${dateTime.day} ${monthText(dateTime.month)}';
    }
  } else if (difference.inDays > 0) {
    return _plural('day', difference.inDays);
  } else if (difference.inHours > 0) {
    return _plural('hour', difference.inHours);
  } else if (difference.inMinutes > 0) {
    return _plural('minute', difference.inMinutes);
  } else {
    return _plural('second', difference.inSeconds);
  }
}
