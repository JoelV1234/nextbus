import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nextbus/locator.dart';
import 'package:nextbus/providers/shared_preferences_provider.dart';
import 'package:nextbus/providers/sms_provider.dart';
import 'package:nextbus/providers/transit_provider.dart';
import 'package:nextbus/ui/screens/gate_screen/gate_provider.dart';
import 'package:nextbus/ui/screens/gate_screen/gate_screen.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SmsProvider()),
        Provider(create: (_) => SharedPreferencesProvider()),
        ChangeNotifierProxyProvider<SmsProvider, TransitProvider>(
          update: (_, sms, transitProvider) => transitProvider ?? TransitProvider(sms), 
          create: (BuildContext context) => TransitProvider(
            context.read<SmsProvider>()),
        ),
        ChangeNotifierProxyProvider2<
          SmsProvider,
          SharedPreferencesProvider,
          GateProvider
        >(
          create:
              (context) => GateProvider(
                context.read<SharedPreferencesProvider>(),
                context.read<SmsProvider>(),
              ),
          update:
              (context, sms, prefs, previous) =>
                  previous ?? GateProvider(prefs, sms),
        ),
      ],
      child: const NextBusApp(),
    ),
  );
}

class NextBusApp extends StatelessWidget {
  const NextBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextBus',
      debugShowCheckedModeBanner: false, // Clean UI without debug banner
      theme: AppTheme.lightTheme,
      home: const GateScreen(),
    );
  }
}
