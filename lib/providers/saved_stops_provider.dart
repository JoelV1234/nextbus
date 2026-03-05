import 'package:flutter/material.dart';
import '../models/saved_bus_pair.dart';
import '../services/storage_service.dart';

class SavedStopsProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<SavedBusPair> _savedStops = [];

  SavedStopsProvider(this._storageService) {
    _loadSavedStops();
  }

  List<SavedBusPair> get savedStops => List.unmodifiable(_savedStops);

  Future<void> _loadSavedStops() async {
    _savedStops = await _storageService.loadBusPairs();
    notifyListeners();
  }

  Future<void> addSavedStop(SavedBusPair pair) async {
    if (!_savedStops.contains(pair)) {
      _savedStops.add(pair);
      await _storageService.saveBusPairs(_savedStops);
      notifyListeners();
    }
  }

  Future<void> removeSavedStop(SavedBusPair pair) async {
    _savedStops.remove(pair);
    await _storageService.saveBusPairs(_savedStops);
    notifyListeners();
  }

  bool isSaved(String stopId, String busLine) {
    return _savedStops.any((p) => p.stopId == stopId && p.busLine == busLine);
  }

  Future<void> toggleSavedStop(String stopId, String busLine) async {
    final pair = SavedBusPair(stopId: stopId, busLine: busLine);
    if (isSaved(stopId, busLine)) {
      await removeSavedStop(pair);
    } else {
      await addSavedStop(pair);
    }
  }
}
