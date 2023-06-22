import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/helpers/get_icon.dart';
import 'package:weather_app/model/weather_today_model.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/pages/favourite_page.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/util/weekly_forecast_tile.dart';
import 'package:weather_app/util/today_forecast_tile.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/helpers/get_date_time.dart';

import '../model/db_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add database on HIVE
  final mainBox = Hive.box("mainBox");
  DB db = DB();

  // this key needs for checking is textformfield empty
  final _formKey = GlobalKey<FormState>();

  // controller for textformfield
  final TextEditingController _cityController = TextEditingController();

  // url
  WeatherApiClient client = WeatherApiClient();
  Weather? dataNow;
  WeatherToday? dataToday;

  Future<void> getData(String location) async {
    dataNow = await client.getCurrentWeather(location);
    dataToday = await client.getTodayWeather(location);
  }

  // todo: add timer that update info every minute, cause we need to update time anyway

  @override
  void initState() {
    if (mainBox.get("HISTORY") == null) {
      db.initData();
    } else {
      db.loadData();
    }
    super.initState();
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
                            return 'Please, enter city name';
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
                                  // change current city
                                  db.myCity = _cityController.text.toString();

                                  // todo: check 404 error,
                                  // is there thus city or not?
                                });

                                // this need for showing last 6 entered cities without repeats
                                bool c = true;
                                for (int j = 0; j < db.history!.length; j++) {
                                  if (j < 7 && db.history![j] == db.myCity!) {
                                    c = false;
                                  }
                                }
                                if (c) {
                                  setState(() {
                                    db.history!.insert(0, db.myCity!);
                                    db.updateDB();
                                  });
                                }

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
                      child: ListView.builder(
                        itemCount:
                            db.history!.length > 6 ? 6 : db.history!.length,
                        itemBuilder: (builder, index) {
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                              child: Text(
                                db.history![index],
                                style: TextStyle(fontSize: 17),
                              ),
                              onTap: () {
                                _cityController.text = db.history![index];
                              },
                            ),
                          );
                        },
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
      child: db.myCity != null
          ? Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FavouritePage()));
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
                future: getData(db.myCity!),
                builder: (context, snapshot) {
                  try {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/${dataNow!.weather}.jpg"),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            borderRadius:
                                                BorderRadius.circular(35),
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              25, 0, 25, 25),
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
                                                      ' - ${dataNow!.cityName} - ',
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                        fontSize: 30,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            selectedHomeColor,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: changeCity,
                                                ),

                                                // date
                                                Text(
                                                  getDate(dataNow!.timezone),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.bebasNeue(
                                                    color: Colors.white,
                                                    fontSize: 21,
                                                  ),
                                                ),

                                                // time
                                                Text(
                                                  getTime(dataNow!.timezone),
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
                                                      '  ${dataNow!.temperature}°',
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                        fontSize: 130,
                                                        color:
                                                            selectedHomeColor,
                                                      ),
                                                    ),

                                                    // weather
                                                    Text(
                                                      "${dataNow!.weather}",
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                        style: GoogleFonts
                                                            .bebasNeue(
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ' ${dataNow!.feelsLike}°',
                                                      style:
                                                          GoogleFonts.bebasNeue(
                                                        fontSize: 27,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // main info
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  width: 300,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
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
                                                            '${dataNow!.wind} m / s',
                                                            style: GoogleFonts
                                                                .bebasNeue(
                                                                    fontSize:
                                                                        18),
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
                                                            Icons
                                                                .wind_power_rounded,
                                                            color: Colors.white,
                                                            // size: 30,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '${dataNow!.windDirection}',
                                                            style: GoogleFonts
                                                                .bebasNeue(
                                                                    fontSize:
                                                                        18),
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
                                                            CupertinoIcons
                                                                .drop_fill,
                                                            color: Colors.white,
                                                            // size: 30,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '${dataNow!.humidity} %',
                                                            style: GoogleFonts
                                                                .bebasNeue(
                                                                    fontSize:
                                                                        18),
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
                                            borderRadius:
                                                BorderRadius.circular(35),
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "today's weather",
                                            style: GoogleFonts.bebasNeue(
                                                fontSize: 28),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),

                                      // list view of today's forecast
                                      Container(
                                        height: 120,
                                        child: ListView.builder(
                                          itemCount:
                                              dataToday!.temperature!.length,
                                          itemBuilder: (context, index) {
                                            return DayForecastTile(
                                              temperature: dataToday!
                                                  .temperature![index],
                                              time: dataToday!.dt![index]
                                                  .split(' ')[1]
                                                  .substring(0, 5),
                                              icon: getIcon(
                                                  dataToday!.weather![index]),
                                            );
                                          },
                                          scrollDirection: Axis.horizontal,
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
                                            borderRadius:
                                                BorderRadius.circular(35),
                                          ),
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            'Weekly Forecast',
                                            style: GoogleFonts.bebasNeue(
                                                fontSize: 28),
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
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
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
            )
          : Scaffold(
              body: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black38,
                  ),
                  width: 350,
                  height: 230,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Find your city..',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 20,
                          letterSpacing: 2,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please, enter city name';
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
                                      // change current city
                                      db.myCity =
                                          _cityController.text.toString();
                                      db.history!.insert(0, db.myCity!);

                                      db.updateMyCity();
                                      db.updateDB();

                                      // todo: check 404 error,
                                      // is there this city or not?
                                    });

                                    _cityController.clear();
                                  }
                                },
                                child: Icon(Icons.check_rounded),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
