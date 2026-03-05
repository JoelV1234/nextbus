import '../models/bus_arrival/bus_arrival.dart';

class SmsParser {
  /// Regular expression to match valid arrival times and metadata.
  /// Example format: "53395 [152] 3:28p* 3:47p*"
  static final RegExp _arrivalRegex = RegExp(r'(\d+)\s+\[([\w\d]+)\]\s+(.*)');

  /// Regular expression to match individual time entries like "3:28p*" or "12:09pC"
  static final RegExp _timeRegex = RegExp(r'(\d{1,2}:\d{2}[ap])([\*C])?');

  /// Regular expression for invalid bus route
  static final RegExp _invalidRouteRegex = RegExp(
    r'Bus route #([\w\d]+) is not valid for stop (\d+)\.',
  );

  /// Regular expression for invalid stop number
  static final RegExp _invalidStopRegex = RegExp(
    r'Stop number (\d+) is not valid\.',
  );

  static List<BusArrival> parseArrivals(String message) {
    if (message.isEmpty) return [];

    // Check for "invalid route" error
    final routeMatch = _invalidRouteRegex.firstMatch(message);
    if (routeMatch != null) {
      final route = routeMatch.group(1);
      final stop = routeMatch.group(2);
      throw Exception('Route #$route is not valid for stop $stop.');
    }

    // Check for "invalid stop" error
    final stopMatch = _invalidStopRegex.firstMatch(message);
    if (stopMatch != null) {
      final stop = stopMatch.group(1);
      throw Exception('Stop #$stop is not valid.');
    }

    // Attempt to parse successful arrivals
    final mainMatch = _arrivalRegex.firstMatch(message);
    if (mainMatch == null) return [];

    final routeNumber = mainMatch.group(2) ?? '';
    final timesContent = mainMatch.group(3) ?? '';
    final now = DateTime.now();

    final List<BusArrival> arrivals = [];
    final timeMatches = _timeRegex.allMatches(timesContent);

    for (final match in timeMatches) {
      final timeStr = match.group(1);
      final suffix = match.group(2);

      final isScheduled = suffix == '*';
      final isCancelled = suffix == 'C';

      if (timeStr != null) {
        try {
          final arrivalTime = _parseSmsTime(timeStr, now);
          arrivals.add(
            BusArrival(
              routeNumber: routeNumber,
              estimatedArrival: arrivalTime,
              timeUpdated: now,
              isScheduled: isScheduled,
              isCancelled: isCancelled,
            ),
          );
        } catch (e) {
          // Skip invalid times
          continue;
        }
      }
    }

    return arrivals;
  }

  static DateTime _parseSmsTime(String timeStr, DateTime referenceDate) {
    // Format: "3:28p" or "10:05a"
    final parts = timeStr.substring(0, timeStr.length - 1).split(':');
    if (parts.length != 2) throw const FormatException('Invalid time format');

    int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    final isPm = timeStr.endsWith('p');

    if (isPm && hour < 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    DateTime result = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      hour,
      minute,
    );

    // If the parsed time is significantly in the past compared to referenceDate,
    // it's likely for the next day.
    if (result.isBefore(referenceDate.subtract(const Duration(hours: 2)))) {
      result = result.add(const Duration(days: 1));
    }

    return result;
  }
}
