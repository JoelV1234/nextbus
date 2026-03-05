import 'package:flutter/material.dart';
import 'package:nextbus/locator.dart';
import 'package:nextbus/providers/shared_preferences_provider.dart';
import 'package:nextbus/providers/sms_provider.dart';
import 'package:nextbus/services/permission_service.dart';
import 'package:nextbus/ui/screens/gate_screen/gate_state.dart';

class GateProvider extends ChangeNotifier {
  final SharedPreferencesProvider sharedPreferencesProvider;
  final SmsProvider smsProvider;
  bool initialised = false;
  late GateState gateState;

  GateProvider(this.sharedPreferencesProvider, this.smsProvider);

  Future<void> requestPermissions() async {
    await smsProvider.requestPermissions();
  }

  Future<GateState> getinitalGateState() async {
    final prefs = await sharedPreferencesProvider.init();
    if (prefs.getBool('first_time') == null) {
      gateState = GateState.firstTime;
    } else {
      final hasPermission = await locator<PermissionService>().isSmsAllowed();
      if (!hasPermission) {
        gateState = GateState.noSmsPermission;
      } else {
        gateState = GateState.setupComplete;
      }
    }
    initialised = true;
    notifyListeners();
    return gateState;
  }

  Future<bool> setFirstTime() async {
    final status = await sharedPreferencesProvider.prefs.setBool(
      'first_time',
      true,
    );
    gateState = GateState.noSmsPermission;
    notifyListeners();
    return status;
  }

  Future<void> getSmsPermission() async {
    await smsProvider.requestPermissions();
    gateState = GateState.setupComplete;
    notifyListeners();
  }

  Future<void> listenIncomingSms(
    dynamic onNewMessage,
    dynamic onBackgroundMessage,
  ) async {
    await smsProvider.listenIncomingSms(onNewMessage, onBackgroundMessage);
  }
}
