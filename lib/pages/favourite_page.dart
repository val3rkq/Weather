import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/util/city_weather_card.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
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
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: [
                            CityWeatherCard(
                              temperature: 22,
                              city: 'Los Angeles',
                              country: 'USA',
                              windSpeed: 7,
                              humidity: 51,
                            ),
                            CityWeatherCard(
                              temperature: 19,
                              city: 'New York',
                              country: 'USA',
                              windSpeed: 19,
                              humidity: 85,
                            ),
                            CityWeatherCard(
                              temperature: 30,
                              city: 'Madrid',
                              country: 'Spain',
                              windSpeed: 3,
                              humidity: 13,
                            ),
                            CityWeatherCard(
                              temperature: 28,
                              city: 'Chisinau',
                              country: 'Moldova',
                              windSpeed: 8,
                              humidity: 47,
                            ),
                            CityWeatherCard(
                              temperature: 28,
                              city: 'Chicago',
                              country: 'USA',
                              windSpeed: 10,
                              humidity: 40,
                            ),
                            CityWeatherCard(
                              temperature: 15,
                              city: 'London',
                              country: 'Great Britain',
                              windSpeed: 9,
                              humidity: 70,
                            ),
                            CityWeatherCard(
                              temperature: 28,
                              city: 'Moscow',
                              country: 'Russia',
                              windSpeed: 13,
                              humidity: 35,
                            ),
                          ],
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
