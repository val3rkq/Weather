import 'dart:math';
import 'package:weather_app/helpers/get_wind_direction.dart';

class Weather {
  String? cityName;
  String? countryName;
  int? timezone;
  String? weather;
  int? temperature;
  int? feelsLike;
  int? humidity;
  int? wind;
  String? windDirection;

  Weather({
    this.cityName,
    this.countryName,
    this.timezone,
    this.weather,
    this.temperature,
    this.feelsLike,
    this.humidity,
    this.wind,
    this.windDirection,
  });


  // function to parse JSON file into the model
  Weather.fromJSON(Map<String, dynamic> json) {
    cityName = json['name'];
    countryName = json['country'];
    timezone = json['timezone'];
    weather = json['weather'][0]['main'].toString().toLowerCase();
    temperature = (json['main']['temp'] - 273).round();
    feelsLike = (json['main']['feels_like'] - 273).round();
    humidity = json['main']['humidity'];
    wind = (json['wind']['speed']).round();
    windDirection = getWindDirection(json['wind']['deg']);
  }
}
