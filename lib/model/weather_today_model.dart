
class WeatherToday {
  List<String>? weather = [];
  List<int>? temperature = [];
  List<String>? dt = [];

  WeatherToday({
    this.weather,
    this.temperature,
    this.dt,
  });


  // function to parse JSON file into the model
  WeatherToday.fromJSON(Map<String, dynamic> json) {

    for (int i = 0; i < 8; i++) {
      weather!.add(json['list'][i]['weather'][0]['main'].toString().toLowerCase());
      temperature!.add((json['list'][i]['main']['temp'] - 273).round());
      dt!.add(json['list'][i]['dt_txt']);
    }

  }
}