import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_today_model.dart';
import 'package:weather_app/model/weather_model.dart';

class WeatherApiClient {

  // current weather
  Future<Weather>? getCurrentWeather(String? location) async {
    String url = 'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=0af02bd750738a59b91c3d6d76b61662';
    var endpoint = Uri.parse(url);
    var response = await http.get(endpoint);


    print(response.statusCode);

    var body = jsonDecode(response.body);
    return Weather.fromJSON(body);
  }

  // weather for day
  Future<WeatherToday>? getTodayWeather(String? location) async {
    String url = 'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=0af02bd750738a59b91c3d6d76b61662&cnt=8';
    var endpoint = Uri.parse(url);
    var response = await http.get(endpoint);


    print(response.statusCode);

    var body = jsonDecode(response.body);
    return WeatherToday.fromJSON(body);
  }

  //weather for week
  // Future<WeatherToday>? getWeekWeather(String? location) async {
  //   String url = 'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=0af02bd750738a59b91c3d6d76b61662&cnt=8';
  //   var endpoint = Uri.parse(url);
  //   var response = await http.get(endpoint);
  //
  //
  //   print(response.statusCode);
  //
  //   var body = jsonDecode(response.body);
  //   return WeatherToday.fromJSON(body);
  // }
}
