import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_bus_pair.dart';

class StorageService {
  static const String _savedStopsKey = 'saved_bus_stops';

  Future<void> saveBusPairs(List<SavedBusPair> pairs) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(pairs.map((p) => p.toJson()).toList());
    await prefs.setString(_savedStopsKey, encoded);
  }

  Future<List<SavedBusPair>> loadBusPairs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_savedStopsKey);
    if (encoded == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(encoded);
      return decoded
          .map((item) => SavedBusPair.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return empty list if decoding fails
      return [];
    }
  }
}
