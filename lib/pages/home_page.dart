import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/helpers/get_icon.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/pages/favourite_page.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/util/weekly_forecast_tile.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_app/util/today_forecast_tile.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/helpers/get_date.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // change later
  String currentCity = 'Sydney';

  // this key needs for checking is textformfield empty
  final _formKey = GlobalKey<FormState>();

  // controller for textformfield
  final TextEditingController _cityController = TextEditingController();

  // url
  WeatherApiClient client = WeatherApiClient();
  Weather? data;

  Future<void> getData(String location) async {
    data = await client.getCurrentWeather(location);
    print(data);
  }

  @override
  void dispose() {
    _cityController.clear();
    super.dispose();
  }

  // show modal bottom sheet for changing city
  void changeCity() {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 430,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // title
                    Text(
                      'Change city',
                      style: GoogleFonts.bebasNeue(fontSize: 25),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    // seacrh field
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter city name';
                          }
                          return null;
                        },
                        controller: _cityController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Enter city name',
                          prefixIcon: Icon(Icons.search_rounded),
                          suffix: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  currentCity = _cityController.text.toString();
                                });
                                _cityController.clear();
                                Navigator.pop(context);
                              }
                            },
                            child: Icon(Icons.check_rounded),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    // proposed cities
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('New York'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Los Angeles'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Chicago'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('London'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Paris'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavouritePage()));
            },
            icon: Icon(
              CupertinoIcons.heart_fill,
              size: 30,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: changeCity,
              icon: Icon(
                Icons.search_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: getData(currentCity),
          builder: (context, snapshot) {
            try {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/${data!.weather}.jpg"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        color: Color(0x80000000),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 35, 15, 20),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // main info about today weather
                                Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 330,
                                    height: 470,
                                    decoration: BoxDecoration(
                                      // color: selectedHomeColor,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // city
                                          GestureDetector(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                ' - ${data!.cityName} - ',
                                                style: GoogleFonts.bebasNeue(
                                                  fontSize: 30,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w700,
                                                  color: selectedHomeColor,
                                                ),
                                              ),
                                            ),
                                            onTap: changeCity,
                                          ),

                                          // date
                                          Text(
                                            getDate(data!.timezone),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.bebasNeue(
                                              color: Colors.white,
                                              fontSize: 21,
                                            ),
                                          ),

                                          // time
                                          Text(
                                            getTime(data!.timezone),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.bebasNeue(
                                              color: Colors.white,
                                              fontSize: 25,
                                            ),
                                          ),

                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // temperature
                                              Text(
                                                '  ${data!.temperature}°',
                                                style: GoogleFonts.bebasNeue(
                                                  fontSize: 130,
                                                  color: selectedHomeColor,
                                                ),
                                              ),

                                              // weather
                                              Text(
                                                "${data!.weather}",
                                                style: GoogleFonts.bebasNeue(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.15,
                                                  // backgroundColor: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          // feels like
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 5),
                                                child: Text(
                                                  'Feels like',
                                                  style: GoogleFonts.bebasNeue(
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ' ${data!.feelsLike}°',
                                                style: GoogleFonts.bebasNeue(
                                                  fontSize: 27,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // main info
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            width: 300,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // wind's speed
                                                Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.wind,
                                                      color: Colors.white,
                                                      // size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${data!.wind} km / h',
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                              fontSize: 18),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),

                                                // wind's direction
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.wind_power_rounded,
                                                      color: Colors.white,
                                                      // size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${data!.windDirection}',
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                              fontSize: 18),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),

                                                // humidity
                                                Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.drop_fill,
                                                      color: Colors.white,
                                                      // size: 30,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${data!.humidity} %',
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                              fontSize: 18),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                // today's weather
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      // color: selectedHomeColor,
                                      color: Color(0x33000000),
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "today's weather",
                                      style:
                                          GoogleFonts.bebasNeue(fontSize: 28),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),

                                // list view of today's forecast
                                Container(
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      DayForecastTile(
                                        temperature: 16,
                                        time: '08:00',
                                        icon: getIcon('clouds'),
                                      ),
                                      DayForecastTile(
                                        temperature: 19,
                                        time: '11:00',
                                        icon: getIcon('cloud sunny'),
                                      ),
                                      DayForecastTile(
                                        temperature: 22,
                                        time: '14:00',
                                        icon: getIcon(''),
                                      ),
                                      DayForecastTile(
                                        temperature: 21,
                                        time: '17:00',
                                        icon: getIcon('rain'),
                                      ),
                                      DayForecastTile(
                                        temperature: 20,
                                        time: '21:00',
                                        icon: getIcon('thunderstorm'),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 35,
                                ),

                                // weekly forecast
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      'Weekly Forecast',
                                      style:
                                          GoogleFonts.bebasNeue(fontSize: 28),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),

                                // list view of weekly forecast
                                Container(
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      WeeklyForecastTile(
                                        temperature: 21,
                                        day: '12 sep 2023',
                                      ),
                                      WeeklyForecastTile(
                                        temperature: 25,
                                        day: '13 sep 2023',
                                      ),
                                      WeeklyForecastTile(
                                        temperature: 19,
                                        day: '14 sep 2023',
                                      ),
                                      WeeklyForecastTile(
                                        temperature: 17,
                                        day: '15 sep 2023',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            } catch (error) {
              print(error.toString());
            }

            return Container();
          },
        ),
      ),
    );
  }
}
