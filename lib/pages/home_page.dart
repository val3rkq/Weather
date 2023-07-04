import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/helpers/get_icon.dart';
import 'package:weather_app/model/weather_today_model.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/weather_week_model.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/util/submit_button.dart';
import 'package:weather_app/util/week_forecast_tile.dart';
import 'package:weather_app/util/today_forecast_tile.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/helpers/get_date_time.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:weather_app/util/async_text_field/async_field_validation_form_bloc.dart';
import 'package:weather_app/util/async_text_field/loading_dialog.dart';

import '../model/db_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // add database on HIVE
  var mainBox = Hive.box("mainBox");
  DB db = DB();

  // this key needs for checking is textformfield empty
  final _formKey = GlobalKey<FormState>();

  // url
  WeatherApiClient client = WeatherApiClient();
  Weather? dataNow;
  WeatherToday? dataToday;
  WeatherWeek? dataWeek;

  Future<void> getData(String location) async {
    dataNow = await client.getCurrentWeather(location);
    dataToday = await client.getTodayWeather(location);
    dataWeek = await client.getWeekWeather(location);
  }

  void addToHistoryList() {
    setState(() {
      db.history!.insert(0, db.myCity!);
      db.updateDB();
    });
  }

  bool isBottomSheetOpened = false;

  // show modal bottom sheet with textformfield for changing city
  void changeCity(dynamic formBloc) {
    isBottomSheetOpened = true;
    showModalBottomSheet(
      context: context,
      elevation: 0,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 400,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        Center(
                          child: Text(
                            'Change city',
                            style: GoogleFonts.bebasNeue(fontSize: 25),
                          ),
                        ),
                        GestureDetector(
                          child: Icon(Icons.check_rounded),
                          onTap: formBloc.submit,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    // seacrh field
                    Form(
                      key: _formKey,
                      child: TextFieldBlocBuilder(
                        textFieldBloc: formBloc.city,
                        suffixButton: SuffixButton.asyncValidating,
                        decoration: const InputDecoration(
                          hintText: 'Enter city name',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    // proposed cities
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            db.history!.length > 5 ? 5 : db.history!.length,
                        itemBuilder: (builder, index) {
                          return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                db.history![index],
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            onTap: () {
                              formBloc.city
                                  .updateInitialValue(db.history![index]);
                              formBloc.submit;
                            },
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
    ).whenComplete(() {
      // make textformfield empty
      formBloc.city.updateInitialValue('');

      isBottomSheetOpened = false;
    });
  }

  int getTemperature(int temperature, DB db) {
    if (db.temperatureUnit == '°F') {
      return (temperature * 9 / 5 + 32).round();
    }
    return temperature;
  }

  int getWindSpeed(int windSpeed, DB db) {
    if (db.windSpeedUnit == 'km / h') {
      return (windSpeed * 3.6).round();
    } else if (db.windSpeedUnit == 'mph / h') {
      return (windSpeed * 2.2).round();
    }
    return windSpeed;
  }

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsyncFieldValidationFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<AsyncFieldValidationFormBloc>();

          return FormBlocListener<AsyncFieldValidationFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) {
              LoadingDialog.hide(context);
            },
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              // update city
              setState(() {
                if (db.myCity == null) {
                  // set default city
                  db.myCity = formBloc.city.value.toString();
                  db.updateMyCity();
                } else {
                  // update city but not save it like default
                  db.myCity = formBloc.city.value.toString();
                }
              });

              // this need for showing last 6 entered cities without repeats
              bool c = true;
              for (int j = 0; j < db.history!.length; j++) {
                if (j < 5 && db.history![j] == db.myCity!) {
                  c = false;
                }
              }
              if (c) {
                setState(() {
                  db.history!.insert(0, db.myCity!);
                  db.updateDB();
                });
              }

              // make textformfield empty
              formBloc.city.updateInitialValue('');

              // close bottom sheet
              if (isBottomSheetOpened) {
                Navigator.pop(context);
                isBottomSheetOpened = false;
              }
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)));
            },
            child: SafeArea(
              child: db.myCity != null

                  // home page with your city
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
                                builder: (context) => SettingsPage()));
                          },
                          icon: Icon(
                            Icons.settings_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              changeCity(formBloc);
                            },
                            icon: Icon(
                              Icons.search_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      bottomSheet:
                          Padding(padding: EdgeInsets.only(bottom: 50)),
                      body: RefreshIndicator(
                        onRefresh: () async {
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: getData(db.myCity!),
                          builder: (context, snapshot) {
                            try {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      // clouds can be different :)
                                      image: AssetImage(dataNow!.weather ==
                                              'clouds'
                                          ? "assets/${dataNow!.weatherDesc}.jpg"
                                          : "assets/${dataNow!.weather}.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Color(0x70000000),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(top: 50),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 0, 15, 25),
                                        child: SizedBox.expand(
                                          child: ListView(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.all(0),
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // main info about today weather
                                                  Center(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 330,
                                                      height: 470,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(35),
                                                      ),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              25, 0, 25, 25),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // city
                                                            GestureDetector(
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  ' - ${dataNow!.cityName} - ',
                                                                  style: GoogleFonts
                                                                      .bebasNeue(
                                                                    fontSize:
                                                                        30,
                                                                    letterSpacing:
                                                                        1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color:
                                                                        selectedHomeColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                changeCity(
                                                                    formBloc);
                                                              },
                                                            ),

                                                            // date
                                                            Text(
                                                              getDate(dataNow!
                                                                  .timezone),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .bebasNeue(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 21,
                                                              ),
                                                            ),

                                                            // time
                                                            Text(
                                                              getTime(dataNow!
                                                                  .timezone),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .bebasNeue(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 25,
                                                              ),
                                                            ),

                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // temperature
                                                                Text(
                                                                  '  ${getTemperature(dataNow!.temperature!, db)}°',
                                                                  style: GoogleFonts
                                                                      .bebasNeue(
                                                                    fontSize:
                                                                        130,
                                                                    color:
                                                                        selectedHomeColor,
                                                                  ),
                                                                ),

                                                                // weather
                                                                Text(
                                                                  "${dataNow!.weather}",
                                                                  style: GoogleFonts
                                                                      .bebasNeue(
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    letterSpacing:
                                                                        1.15,
                                                                    // backgroundColor: Colors.black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Divider(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                            // feels like
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              5),
                                                                  child: Text(
                                                                    'Feels like',
                                                                    style: GoogleFonts
                                                                        .bebasNeue(
                                                                      fontSize:
                                                                          22,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  ' ${getTemperature(dataNow!.feelsLike!, db)} ${db.temperatureUnit}',
                                                                  style: GoogleFonts
                                                                      .bebasNeue(
                                                                    fontSize:
                                                                        27,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            // main info
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              width: 300,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  // wind speed
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        CupertinoIcons
                                                                            .wind,
                                                                        color: Colors
                                                                            .white,
                                                                        // size: 30,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        '${getWindSpeed(dataNow!.wind!, db)} ${db.windSpeedUnit}',
                                                                        style: GoogleFonts.bebasNeue(
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
                                                                        color: Colors
                                                                            .white,
                                                                        // size: 30,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        '${dataNow!.windDirection}',
                                                                        style: GoogleFonts.bebasNeue(
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
                                                                        color: Colors
                                                                            .white,
                                                                        // size: 30,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        '${dataNow!.humidity} %',
                                                                        style: GoogleFonts.bebasNeue(
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
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        // color: selectedHomeColor,
                                                        color:
                                                            Color(0x33000000),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(35),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Text(
                                                        "today's weather",
                                                        style: GoogleFonts
                                                            .bebasNeue(
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
                                                      itemCount: dataToday!
                                                          .temperature!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return DayForecastTile(
                                                          temperature:
                                                              getTemperature(
                                                                  dataToday!
                                                                          .temperature![
                                                                      index],
                                                                  db),
                                                          time: dataToday!
                                                              .dt![index]
                                                              .split(' ')[1]
                                                              .substring(0, 5),
                                                          icon: getIcon(
                                                              dataToday!
                                                                      .weather![
                                                                  index]),
                                                          unit: db
                                                              .temperatureUnit!,
                                                        );
                                                      },
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    height: 35,
                                                  ),

                                                  // forecast for 5 days
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black26,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(35),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Text(
                                                        'Forecast for 5 days',
                                                        style: GoogleFonts
                                                            .bebasNeue(
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
                                                    child: ListView.builder(
                                                      itemCount: dataWeek!
                                                          .temperature!.length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (build, index) {
                                                        return WeekForecastTile(
                                                          temperature:
                                                              getTemperature(
                                                                  dataWeek!
                                                                          .temperature![
                                                                      index],
                                                                  db),
                                                          icon: getIcon(
                                                              dataWeek!
                                                                      .weather![
                                                                  index]),
                                                          day: dataWeek!
                                                              .dt![index]
                                                              .split(' ')[0],
                                                          unit: db
                                                              .temperatureUnit!,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // update weather item
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
                      ),
                    )

                  // page with textformfield in which you will enter your default-city
                  : Scaffold(
                      body: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black38,
                          ),
                          width: 350,
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Find your city..',
                                style: GoogleFonts.bebasNeue(
                                  fontSize: 25,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  padding: EdgeInsets.all(15),
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: formBloc.city,
                                    suffixButton: SuffixButton.asyncValidating,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter city name',
                                      prefixIcon: Icon(Icons.search_rounded),
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                  ),
                                ),
                              ),

                              // submit button
                              SubmitButton(
                                formBloc: formBloc,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
