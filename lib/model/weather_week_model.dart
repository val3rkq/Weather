
class WeatherWeek {
  List<String>? weather = [];
  List<int>? temperature = [];
  List<String>? dt = [];

  WeatherWeek({
    this.weather,
    this.temperature,
    this.dt,
  });


  // function to parse JSON file into the model
  WeatherWeek.fromJSON(Map<String, dynamic> json) {

    // my APIkey is free and i can't use 16-day forecast
    // this way we will get forecast for 5 day at 12 o'clock
    for (int i = 0; i < 40; i+=8) {
      weather!.add(json['list'][i]['weather'][0]['main'].toString().toLowerCase());
      temperature!.add((json['list'][i]['main']['temp'] - 273).round());
      dt!.add(json['list'][i]['dt_txt']);
    }

  }
}