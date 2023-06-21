import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/constants.dart';

class CityWeatherCard extends StatefulWidget {
  const CityWeatherCard({
    super.key,
    required this.temperature,
    required this.city,
    required this.country,
    required this.windSpeed,
    required this.humidity,
    // required this.deleteCity,
  });

  // final String weather;
  final int temperature;
  final String city;
  final String country;
  final int windSpeed;
  final int humidity;

  // final VoidCallback deleteCity;

  @override
  State<CityWeatherCard> createState() => _StateCityWeatherCard();
}

class _StateCityWeatherCard extends State<CityWeatherCard> {
  bool _isDeletable = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: Duration(seconds: 5),
        curve: Curves.elasticInOut,
        child: Container(
          padding: _isDeletable ? EdgeInsets.all(0) : EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: _isDeletable ? Color(0xFFED3733) : cardColor,
          ),
          child: _isDeletable
              ? Stack(
                  children: [
                    Center(
                      child: IconButton(
                        // delete city from list
                        onPressed: () {},
                        icon: Icon(Icons.delete, color: Colors.white,),
                        iconSize: 40,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black45),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isDeletable = false;
                                });
                              },
                              iconSize: 20,
                              icon: Icon(
                                Icons.close_rounded,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // temperature
                            Text(
                              '${widget.temperature} °',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 40,
                              ),
                            ),

                            // city
                            Text(
                              widget.city,
                              style: GoogleFonts.bebasNeue(
                                fontSize: 20,
                                color: selectedHomeColor,
                              ),
                            ),

                            // country
                            Text(
                              widget.country,
                              style: GoogleFonts.bebasNeue(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15),

                        // icon
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(
                            CupertinoIcons.sun_max_fill,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // wind speed
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.wind,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${widget.windSpeed} km / h',
                              style: GoogleFonts.bebasNeue(fontSize: 17),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),

                        // humidity
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.drop_fill,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${widget.humidity} %',
                              style: GoogleFonts.bebasNeue(fontSize: 17),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
      onTap: () {
        setState(() {
          _isDeletable = true;
        });

      },
    );
  }
}
