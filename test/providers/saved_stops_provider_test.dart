import 'package:flutter_test/flutter_test.dart';
import 'package:nextbus/models/saved_bus_pair.dart';
import 'package:nextbus/providers/saved_stops_provider.dart';
import 'package:nextbus/services/storage_service.dart';

class FakeStorageService implements StorageService {
  List<SavedBusPair> _pairs = [];

  @override
  Future<List<SavedBusPair>> loadBusPairs() async {
    return _pairs;
  }

  @override
  Future<void> saveBusPairs(List<SavedBusPair> pairs) async {
    _pairs = List.from(pairs);
  }
}

void main() {
  late SavedStopsProvider provider;
  late FakeStorageService fakeStorage;

  setUp(() {
    fakeStorage = FakeStorageService();
    provider = SavedStopsProvider(fakeStorage);
  });

  test('Initial state should be empty', () {
    expect(provider.savedStops, isEmpty);
  });

  test('Adding a stop should update the list and save', () async {
    final pair = SavedBusPair(stopId: '12345', busLine: '101');
    await provider.addSavedStop(pair);

    expect(provider.savedStops.length, 1);
    expect(provider.savedStops.first, pair);
    expect(await fakeStorage.loadBusPairs(), contains(pair));
  });

  test('Removing a stop should update the list and save', () async {
    final pair = SavedBusPair(stopId: '12345', busLine: '101');
    await provider.addSavedStop(pair);
    await provider.removeSavedStop(pair);

    expect(provider.savedStops, isEmpty);
    expect(await fakeStorage.loadBusPairs(), isEmpty);
  });

  test(
    'Toggling a stop should add if not present and remove if present',
    () async {
      const stopId = '12345';
      const busLine = '101';

      await provider.toggleSavedStop(stopId, busLine);
      expect(provider.isSaved(stopId, busLine), isTrue);

      await provider.toggleSavedStop(stopId, busLine);
      expect(provider.isSaved(stopId, busLine), isFalse);
    },
  );
}
