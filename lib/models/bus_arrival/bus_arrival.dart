class BusArrival {
  final String routeNumber;
  final String? destination;
  final DateTime estimatedArrival;
  final DateTime timeUpdated;
  final bool isCancelled;
  final bool isScheduled;

  BusArrival({
    required this.routeNumber,
    this.destination,
    required this.estimatedArrival,
    required this.timeUpdated,
    this.isCancelled = false,
    this.isScheduled = false,
  });

  int get minutesUntilArrival {
    final now = DateTime.now();
    final difference = estimatedArrival.difference(now);
    return difference.inMinutes > 0 ? difference.inMinutes : 0;
  }

  String get formattedArrivalTime {
    final hour =
        estimatedArrival.hour > 12
            ? estimatedArrival.hour - 12
            : estimatedArrival.hour == 0
            ? 12
            : estimatedArrival.hour;
    final minute = estimatedArrival.minute.toString().padLeft(2, '0');
    final amPm = estimatedArrival.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }
}
