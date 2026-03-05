import 'package:flutter/material.dart';
import '../../models/bus_arrival/bus_arrival.dart';
import '../../theme/app_theme.dart';

class BusArrivalCard extends StatelessWidget {
  final BusArrival arrival;
  final int index;

  const BusArrivalCard({super.key, required this.arrival, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentYellow.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.darkBlue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          arrival.routeNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            arrival.destination ?? 'Bus Arrival',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                arrival.isCancelled
                                    ? Icons.cancel_outlined
                                    : arrival.isScheduled
                                    ? Icons.schedule_rounded
                                    : Icons.bolt_rounded,
                                size: 16,
                                color:
                                    arrival.isCancelled
                                        ? AppTheme.warningRedColor
                                        : arrival.isScheduled
                                        ? Colors.grey
                                        : Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                arrival.isCancelled
                                    ? 'Cancelled'
                                    : arrival.isScheduled
                                    ? 'Scheduled'
                                    : 'Real-time',
                                style: TextStyle(
                                  color:
                                      arrival.isCancelled
                                          ? AppTheme.warningRedColor
                                          : arrival.isScheduled
                                          ? Colors.grey
                                          : Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${arrival.minutesUntilArrival}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            decoration:
                                arrival.isCancelled
                                    ? TextDecoration.lineThrough
                                    : null,
                            color:
                                arrival.isCancelled
                                    ? Colors.grey
                                    : arrival.minutesUntilArrival <= 5
                                    ? AppTheme.accentYellow
                                    : AppTheme.textDark,
                          ),
                        ),
                        Text(
                          'min',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          arrival.formattedArrivalTime,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                arrival.isCancelled
                                    ? Colors.grey.shade400
                                    : AppTheme.textLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
