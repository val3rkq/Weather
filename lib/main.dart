import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/pages/favourite_page.dart';
import 'package:weather_app/pages/home_page.dart';

import 'model/db_model.dart';


void main() async {

  // init Hive
  await Hive.initFlutter();
  var box = await Hive.openBox("mainBox");
  box.deleteAll(box.keys);
  runApp(MyApp());
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
