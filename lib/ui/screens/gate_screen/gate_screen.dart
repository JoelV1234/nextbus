import 'package:flutter/material.dart';
import 'package:nextbus/ui/screens/gate_screen/gate_provider.dart';
import 'package:nextbus/ui/screens/gate_screen/gate_state.dart';
import 'package:nextbus/ui/screens/home_screen.dart';
import 'package:nextbus/ui/screens/info_screen.dart';
import 'package:nextbus/ui/screens/permission_screen.dart';
import 'package:provider/provider.dart';

class GateScreen extends StatefulWidget {
  const GateScreen({super.key});

  @override
  State<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends State<GateScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GateProvider>().getinitalGateState();
  }

  Widget gateWidget(GateState gateState) {
    switch (gateState) {
      case GateState.firstTime:
        return const InfoScreen();
      case GateState.noSmsPermission:
        return const PermissionScreen();
      case GateState.setupComplete:
        return const HomeScreen();
    }
  }

  @override
  void dispose() {
    super.dispose();
    context.read<GateProvider>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    GateProvider gateProvider = context.watch<GateProvider>();
    return Scaffold(
      body:
          gateProvider.initialised
              ? gateWidget(gateProvider.gateState)
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
