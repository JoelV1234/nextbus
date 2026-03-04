class BusArrival {
  final String routeNumber;
  final String destination;
  final DateTime estimatedArrival;
  final bool isDelayed;

  BusArrival({
    required this.routeNumber,
    required this.destination,
    required this.estimatedArrival,
    this.isDelayed = false,
  });

  int get minutesUntilArrival {
    final now = DateTime.now();
    final difference = estimatedArrival.difference(now);
    return difference.inMinutes > 0 ? difference.inMinutes : 0;
  }
}
