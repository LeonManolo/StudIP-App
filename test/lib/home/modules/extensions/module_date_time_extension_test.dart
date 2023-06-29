import 'package:flutter_test/flutter_test.dart';
import 'package:studipadawan/home/modules/extensions/date_time_extensions.dart';

void main() {
  group('toGermainTimeCountdown', () {
    test(
        'Returns correct time string when days, hours, and minutes are present',
        () {
      final startDate = DateTime(2023, 6, 14, 8, 30);
      final futureDate = DateTime(2023, 6, 16, 11, 45);

      final result = futureDate.germanTimeCountdown(countdownStart: startDate);

      expect(result, '2 Tage 3 Stunden 15 Minuten');
    });

    test('Returns correct time string when only hours and minutes are present',
        () {
      final startDate = DateTime(2023, 6, 14, 8, 30);
      final futureDate = DateTime(2023, 6, 14, 12, 15);

      final result = futureDate.germanTimeCountdown(countdownStart: startDate);

      expect(result, '3 Stunden 45 Minuten');
    });

    test('Returns correct time string when only minutes are present', () {
      final startDate = DateTime(2023, 6, 14, 8, 30);
      final futureDate = DateTime(2023, 6, 14, 8, 31);

      final result = futureDate.germanTimeCountdown(countdownStart: startDate);

      expect(result, '1 Minute');
    });

    test('Returns empty string when no time difference', () {
      final startDate = DateTime(2023, 6, 14, 8, 30);
      final futureDate = DateTime(2023, 6, 14, 8, 30);

      final result = futureDate.germanTimeCountdown(countdownStart: startDate);

      expect(result, '');
    });
  });

  group('formattedDateTime', () {
    test('Returns formatted date string in "day.month.year" format', () {
      final date = DateTime(2023, 6, 14, 8, 30);

      final result = date.formattedDateTime();

      expect(result, '14.06.2023 - 08:30');
    });
  });
}
