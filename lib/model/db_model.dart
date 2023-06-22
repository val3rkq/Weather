// this model need to include in this project for hive database
// this db will save selected city and the list of favourite cities

import 'package:hive_flutter/hive_flutter.dart';

class DB {

  List<String>? history;
  String? myCity;

  final mainBox = Hive.box('mainBox');

  void initData() {
    history = [];
  }

  void loadData() {
    myCity = mainBox.get('MYCITY');
    history = mainBox.get('HISTORY');
  }

  void updateDB() {
    mainBox.put('HISTORY', history);
  }

  void updateMyCity() {
    mainBox.put('MYCITY', myCity);
  }

}