import 'package:flutter/material.dart';
import 'package:nextbus/providers/transit_provider.dart';
import 'package:provider/provider.dart';
import '../../models/bus_arrival/bus_arrival.dart';
import '../../models/saved_bus_pair.dart';
import '../../providers/saved_stops_provider.dart';
import '../../theme/app_theme.dart';
import '../widgets/bus_arrival_card.dart';
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
  bool _isSearchValidated = false;
  String _validatedStop = '';
  String _validatedBus = '';

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
    _stopController.addListener(_onInputChanged);
    _busController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    if (_isSearchValidated) {
      if (_stopController.text.trim() != _validatedStop ||
          _busController.text.trim() != _validatedBus) {
        setState(() {
          _isSearchValidated = false;
        });
      }
    }
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
      setState(() {
        _isSearchValidated = true;
        _validatedStop = stopId;
        _validatedBus = busNumber;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSearchValidated = false;
      });
    }
  }

  void _onSavedStopTap(SavedBusPair pair) {
    _stopController.text = pair.stopId;
    _busController.text = pair.busLine;
    _searchBuses();
  }

  void _toggleSave() {
    if (!_isSearchValidated) return;

    final stopId = _stopController.text.trim();
    final busLine = _busController.text.trim();
    if (stopId.isNotEmpty && busLine.isNotEmpty) {
      context.read<SavedStopsProvider>().toggleSavedStop(stopId, busLine);
    }
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
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
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
                              ),
                              const SizedBox(width: 12),
                              Consumer<SavedStopsProvider>(
                                builder: (context, provider, child) {
                                  final isSaved = provider.isSaved(
                                    _stopController.text.trim(),
                                    _busController.text.trim(),
                                  );
                                  return Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                      color:
                                          isSaved
                                              ? AppTheme.accentYellow
                                              : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: IconButton(
                                      onPressed:
                                          _isSearchValidated
                                              ? _toggleSave
                                              : null,
                                      icon: Icon(
                                        isSaved
                                            ? Icons.bookmark_rounded
                                            : Icons.bookmark_add_outlined,
                                        color:
                                            !_isSearchValidated
                                                ? Colors.grey[400]
                                                : isSaved
                                                ? Colors.white
                                                : AppTheme.primaryBlue,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
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

                    if (_arrivalsStream != null || _errorMessage != null)
                      Text(
                        'Live Arrivals',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                  ],
                ),
              ),
            ),

            // Results Section
            if (_errorMessage != null)
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.redAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Oops!',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_arrivalsStream != null)
              StreamBuilder<List<BusArrival>?>(
                stream: _arrivalsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.accentYellow,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  }

                  final arrivals = snapshot.data;

                  if (arrivals == null) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.accentYellow,
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return BusArrivalCard(
                        arrival: arrivals[index],
                        index: index,
                      );
                    }, childCount: arrivals.length),
                  );
                },
              )
            else
              // Empty state before search
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 80,
                          color: AppTheme.textLight.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enter stop and bus number\nto see live arrivals',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textLight),
                        ),
                      ],
                    ),
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
