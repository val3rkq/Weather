// this model need to include in this project for hive database
// this db will save selected city and the list of favourite cities

import 'package:hive_flutter/hive_flutter.dart';

class DB {

  List<String>? history;
  List<String>? favourites;
  String? myCity;

  final mainBox = Hive.box('mainBox');

  void initData() {
    history = [];
    favourites = [];
  }

  void loadData() {
    myCity = mainBox.get('MYCITY');
    history = mainBox.get('HISTORY');
    favourites = mainBox.get('FAVOURITES');
  }

  void updateDB() {
    mainBox.put('HISTORY', history);
    mainBox.put('FAVOURITES', favourites);
  }

  void updateMyCity() {
    mainBox.put('MYCITY', myCity);
  }

}