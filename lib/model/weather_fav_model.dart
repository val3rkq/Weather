import 'package:flutter/cupertino.dart';
import 'package:weather_app/helpers/get_icon.dart';

class WeatherFavModel {
  List<String>? weatherList = [];
  List<int>? temperatureList = [];
  List<String>? cityList = [];
  List<int>? windSpeedList = [];
  List<int>? humidityList = [];


  WeatherFavModel({
    this.weatherList,
    this.temperatureList,
    this.cityList,
    this.windSpeedList,
    this.humidityList,
  });


  // function to parse JSON file into the model
  WeatherFavModel.fromJSON(Map<String, dynamic> json) {
    cityList!.add(json['name']);
    weatherList!.add(json['weather'][0]['main'].toString().toLowerCase());
    temperatureList!.add((json['main']['temp'] - 273).round());
    humidityList!.add(json['main']['humidity']);
    windSpeedList!.add((json['wind']['speed']).round());
  }
}