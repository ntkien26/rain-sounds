Duration parseTime(String input) {
  final parts = input.split(':');

  if (parts.length != 3) throw FormatException('Invalid time format: $input');

  int days;
  int hours;
  int minutes;
  int seconds;
  int milliseconds;
  int microseconds;

  {
    final p = parts[2].split('.');

    if (p.length != 2) throw const FormatException('Invalid time format');

    final p2 = int.parse(p[1]);
    microseconds = p2 % 1000;
    milliseconds = p2 ~/ 1000;

    seconds = int.parse(p[0]);
  }

  minutes = int.parse(parts[1]);

  {
    int p = int.parse(parts[0]);
    hours = p % 24;
    days = p ~/ 24;
  }

  // TODO verify that there are no negative parts

  return Duration(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds);
}

String formatHHMMSS(int seconds) {
  final hours = (seconds / 3600).truncate();
  seconds = (seconds % 3600).truncate();
  final minutes = (seconds / 60).truncate();

  final hoursStr = (hours).toString().padLeft(2, '0');
  final minutesStr = (minutes).toString().padLeft(2, '0');
  final secondsStr = (seconds % 60).toString().padLeft(2, '0');

  if (hours == 0) {
    return '$minutesStr:$secondsStr';
  }

  return '$hoursStr:$minutesStr:$secondsStr';
}