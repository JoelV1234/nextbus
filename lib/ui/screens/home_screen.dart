import 'package:flutter/material.dart';
import 'package:nextbus/providers/transit_provider.dart';
import 'package:provider/provider.dart';
import '../../models/bus_arrival/bus_arrival.dart';
import '../../models/saved_bus_pair.dart';
import '../../providers/saved_stops_provider.dart';
import '../../theme/app_theme.dart';
import '../widgets/live_arrivals_sheet.dart';
import '../widgets/saved_stop_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _stopController = TextEditingController();
  final TextEditingController _busController = TextEditingController();
  Stream<List<BusArrival>?>? _arrivalsStream;
  String? _errorMessage;

  @override
  void dispose() {
    _stopController.dispose();
    _busController.dispose();
    _arrivalsStream?.drain();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _searchBuses() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final stopId = _stopController.text.trim();
    final busNumber = _busController.text.trim();
    context.read<TransitProvider>().refreshArrivalStream();
    setState(() {
      _errorMessage = null;
      _arrivalsStream =
          _arrivalsStream ?? context.read<TransitProvider>().nextBusesStream();
    });

    try {
      await context.read<TransitProvider>().sendSmsToNextBus(stopId, busNumber);

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder:
              (context) => DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.4,
                maxChildSize: 0.9,
                expand: false,
                builder:
                    (context, scrollController) => LiveArrivalsSheet(
                      arrivalsStream: _arrivalsStream!,
                      stopId: stopId,
                      busNumber: busNumber,
                      errorMessage: _errorMessage,
                    ),
              ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder:
              (context) => LiveArrivalsSheet(
                arrivalsStream: const Stream.empty(),
                stopId: stopId,
                busNumber: busNumber,
                errorMessage: _errorMessage,
              ),
        );
      }
    }
  }

  void _onSavedStopTap(SavedBusPair pair) {
    _stopController.text = pair.stopId;
    _busController.text = pair.busLine;
    _searchBuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.directions_bus_filled_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NextBus',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Find your ride in seconds',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Where are you heading?',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(height: 24),

                    // Input Form
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextField(
                            controller: _stopController,
                            decoration: const InputDecoration(
                              labelText: 'Stop ID or Name',
                              hintText: 'e.g. 1st Ave & Main St',
                              prefixIcon: Icon(
                                Icons.place_rounded,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _busController,
                            decoration: const InputDecoration(
                              labelText: 'Bus Number',
                              hintText: 'e.g. 42A',
                              prefixIcon: Icon(
                                Icons.directions_bus_rounded,
                                color: AppTheme.accentYellow,
                              ),
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _searchBuses(),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 56,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _searchBuses,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Find Next Bus',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Consumer<SavedStopsProvider>(
                      builder: (context, provider, child) {
                        if (provider.savedStops.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Favorites',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 130,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: provider.savedStops.length,
                                itemBuilder: (context, index) {
                                  final pair = provider.savedStops[index];
                                  return SavedStopCard(
                                    pair: pair,
                                    onTap: () => _onSavedStopTap(pair),
                                    onRemove:
                                        () => provider.removeSavedStop(pair),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
