import 'package:flutter/material.dart';
import 'package:weather_app/pages/entry_point.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // tz.initializeTimeZones();
  // var locations = tz.timeZoneDatabase.locations;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
