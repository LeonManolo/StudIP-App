extension DateTimeExtension on DateTime {

  int get secondsSinceEpoch {
    return millisecondsSinceEpoch ~/ 1000;

  }

}