import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/helpers/get_icon.dart';
import 'package:weather_app/model/db_model.dart';
import 'package:weather_app/model/weather_fav_model.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/weather_today_model.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/util/city_weather_card.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  // add database on HIVE
  var mainBox = Hive.box("mainBox");
  DB db = DB();

  // url
  WeatherApiClient client = WeatherApiClient();
  Weather? dataNow;
  WeatherToday? dataToday;
  WeatherFavModel? dataFavCity;

  Future<void> getData(String location) async {
    dataNow = await client.getCurrentWeather(location);
    dataToday = await client.getTodayWeather(location);
  }

  @override
  void initState() {
    if (mainBox.get("HISTORY") == null) {
      db.initData();
    } else {
      db.loadData();
    }
    print(db.favourites);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // seacrh field
                  Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        prefixIcon: Icon(Icons.search_rounded),
                        border: InputBorder.none,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xFFFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  // grid view of cards with temperature in different cities
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: GridView.builder(
                          itemCount: db.favourites!.length,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (builder, index) {
                            return FutureBuilder(
                              future: getData(db.favourites![index]),
                              builder: (context, snapshot) {
                                try {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return CityWeatherCard(
                                      temperature:
                                          dataFavCity!.temperatureList![index],
                                      city: dataFavCity!.cityList![index],
                                      weather: dataFavCity!.weatherList![index],
                                      windSpeed:
                                          dataFavCity!.windSpeedList![index],
                                      humidity:
                                          dataFavCity!.humidityList![index],
                                      icon: getIcon(
                                          dataFavCity!.weatherList![index]),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                } catch (error) {
                                  print(error.toString());
                                }
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: cardColor,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
