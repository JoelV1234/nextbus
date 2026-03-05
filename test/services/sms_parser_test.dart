import 'package:flutter_test/flutter_test.dart';
import 'package:nextbus/services/sms_parser.dart';

void main() {
  group('SmsParser Tests', () {
    test('Parse valid arrival message', () {
      const message =
          "53395 [152] 3:28p 3:47p\n\nReal-time Next Bus @ translink.ca Data rates apply";
      final arrivals = SmsParser.parseArrivals(message);

      expect(arrivals.length, 2);
      expect(arrivals[0].routeNumber, '152');
      expect(arrivals[0].isScheduled, false); // no *
      expect(arrivals[0].isCancelled, false); // no C
      expect(arrivals[1].routeNumber, '152');
    });

    test('Parse invalid route error', () {
      const message =
          "Bus route #153 is not valid for stop 53395. Valid bus route is: 152";
      expect(
        () => SmsParser.parseArrivals(message),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'description',
            contains('Route #153 is not valid for stop 53395'),
          ),
        ),
      );
    });

    test('Parse invalid stop error', () {
      const message =
          "Stop number 37371 is not valid. Real-time Next Bus available at translink.ca.";
      expect(
        () => SmsParser.parseArrivals(message),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'description',
            contains('Stop #37371 is not valid'),
          ),
        ),
      );
    });

    test('Parse scheduled time with *', () {
      const message = "53395 [152] 3:28p* 3:47p*";
      final arrivals = SmsParser.parseArrivals(message);

      expect(arrivals.length, 2);
      expect(arrivals[0].isScheduled, true);
    });

    test('Parse cancelled time with C', () {
      const message = "53395 [152] 12:09pC 12:45p";
      final arrivals = SmsParser.parseArrivals(message);

      expect(arrivals.length, 2);
      expect(arrivals[0].isCancelled, true);
      expect(arrivals[0].isScheduled, false);
      expect(arrivals[1].isCancelled, false);
    });
  });
}
