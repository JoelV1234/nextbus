import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    )
  );
  runApp(const NextBusApp());
}

class NextBusApp extends StatelessWidget {
  const NextBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextBus',
      debugShowCheckedModeBanner: false, // Clean UI without debug banner
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
