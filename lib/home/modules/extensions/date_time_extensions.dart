import 'package:intl/intl.dart';

extension ModuleDateTimeExtension on DateTime {
  /// Should be called from the later date. The earlier date should be passed as [countdownStart].
  /// Returns the difference expressed in days, hours and minutes.
  ///
  /// Example: 1 Tag 19 Stunden 5 Minuten
  String germanTimeCountdown({required DateTime countdownStart}) {
    final Duration difference = this.difference(countdownStart);

    final int days = difference.inDays;
    final int hours = difference.inHours % 24;
    final int minutes = (difference.inSeconds / 60).ceil() % 60;

    String timeString = '';

    if (days > 0) {
      timeString += '$days Tag${days > 1 ? 'e' : ''} ';
    }

    if (hours > 0) {
      timeString += '$hours Stunde${hours > 1 ? 'n' : ''} ';
    }

    if (minutes > 0) {
      timeString += '$minutes Minute${minutes > 1 ? 'n' : ''} ';
    }

    return timeString.trim();
  }

  String formattedDateTime() {
    return DateFormat('dd.MM.yyyy - HH:mm').format(this);
  }
}
