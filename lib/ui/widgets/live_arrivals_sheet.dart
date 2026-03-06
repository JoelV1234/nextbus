import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bus_arrival/bus_arrival.dart';
import '../../providers/saved_stops_provider.dart';
import '../../theme/app_theme.dart';
import 'bus_arrival_card.dart';

class LiveArrivalsSheet extends StatelessWidget {
  final Stream<List<BusArrival>?> arrivalsStream;
  final String? errorMessage;
  final String stopId;
  final String busNumber;

  const LiveArrivalsSheet({
    super.key,
    required this.arrivalsStream,
    required this.stopId,
    required this.busNumber,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                const Icon(
                  Icons.wifi_tethering_rounded,
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Arrivals',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        'Stop $stopId • Bus $busNumber',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<SavedStopsProvider>(
                  builder: (context, provider, child) {
                    final isSaved = provider.isSaved(stopId, busNumber);
                    return IconButton(
                      onPressed:
                          () => provider.toggleSavedStop(stopId, busNumber),
                      icon: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_add_outlined,
                        color:
                            isSaved
                                ? AppTheme.accentYellow
                                : AppTheme.primaryBlue,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            isSaved
                                ? AppTheme.accentYellow.withOpacity(0.1)
                                : Colors.grey[200],
                        padding: const EdgeInsets.all(8),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child:
                errorMessage != null
                    ? _buildErrorState(context, errorMessage!)
                    : StreamBuilder<List<BusArrival>?>(
                      stream: arrivalsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingState();
                        }

                        if (snapshot.hasError) {
                          return _buildErrorState(
                            context,
                            snapshot.error.toString(),
                          );
                        }

                        final arrivals = snapshot.data;

                        if (arrivals == null) {
                          return _buildLoadingState();
                        }

                        if (arrivals.isEmpty) {
                          return _buildEmptyState();
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: arrivals.length,
                          itemBuilder: (context, index) {
                            return BusArrivalCard(
                              arrival: arrivals[index],
                              index: index,
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: CircularProgressIndicator(color: AppTheme.accentYellow),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Oops!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textLight),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.timer_off_outlined, size: 48, color: AppTheme.textLight),
            SizedBox(height: 16),
            Text(
              'No upcoming arrivals found',
              style: TextStyle(color: AppTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
