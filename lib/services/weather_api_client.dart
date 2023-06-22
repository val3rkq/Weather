import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';

class WeatherApiClient {
  Future<Weather>? getCurrentWeather(String? location) async {
    String url = 'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=0af02bd750738a59b91c3d6d76b61662';
    var endpoint = Uri.parse(url);
    var response = await http.get(endpoint);


    print(response.statusCode);

    var body = jsonDecode(response.body);
    return Weather.fromJSON(body);

    // if (response.statusCode == 200) {
    //   // success
    // } else if(response.statusCode == 404){
    //   // not found
    // } else if(response.statusCode == 500){
    //   // server not responding.
    // } else {
    //   // some other error or might be CORS policy error. you can add your url in CORS policy.
    // }

  }
}
