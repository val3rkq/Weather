import 'package:hive_flutter/hive_flutter.dart';

class DB {

  List<String>? history;
  List<String>? favourites;
  String? myCity;
  String? temperatureUnit;
  String? windSpeedUnit;

  final mainBox = Hive.box('mainBox');

  void initData() {
    history = [];
    favourites = [];
    temperatureUnit = '°C';
    windSpeedUnit = 'm / s';
  }

  void loadData() {
    myCity = mainBox.get('MYCITY');
    history = mainBox.get('HISTORY');
    favourites = mainBox.get('FAVOURITES');

    temperatureUnit = mainBox.get('TEMPERATURE');
    windSpeedUnit = mainBox.get('WINDSPEED');
  }

  void updateDB() {
    mainBox.put('HISTORY', history);
    mainBox.put('FAVOURITES', favourites);
    mainBox.put('TEMPERATURE', temperatureUnit);
    mainBox.put('WINDSPEED', windSpeedUnit);
  }

  void updateMyCity() {
    mainBox.put('MYCITY', myCity);
  }

}