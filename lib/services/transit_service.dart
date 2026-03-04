import 'dart:math';
import '../models/bus_arrival.dart';

class TransitService {
  final Random _random = Random();

  Future<List<BusArrival>> getNextBuses(String stopId, String routeNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Special case for an empty or invalid search
    if (stopId.isEmpty || routeNumber.isEmpty) {
      throw Exception('Stop ID and Route Number are required');
    }

    final now = DateTime.now();
    
    // Generate 3-5 dummy upcoming buses for the given route
    final int count = _random.nextInt(3) + 3;
    final List<BusArrival> arrivals = [];

    int currentOffsetMinutes = _random.nextInt(5);

    for (int i = 0; i < count; i++) {
      currentOffsetMinutes += _random.nextInt(15) + 5; // intervals of 5 to 20 mins
      
      arrivals.add(
        BusArrival(
          routeNumber: routeNumber.toUpperCase(),
          destination: 'Downtown Transit Center',
          estimatedArrival: now.add(Duration(minutes: currentOffsetMinutes)),
          isDelayed: _random.nextDouble() > 0.8, // 20% chance of delay
        )
      );
    }

    return arrivals;
  }
}
