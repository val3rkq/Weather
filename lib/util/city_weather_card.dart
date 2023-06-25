import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/model/db_model.dart';
import 'package:weather_app/model/weather_model.dart';

class CityWeatherCard extends StatefulWidget {
  CityWeatherCard({
    super.key,
    required this.temperature,
    required this.city,
    required this.weather,
    required this.windSpeed,
    required this.humidity,
    required this.icon,
  });

  final int temperature;
  final String city;
  final String weather;
  final int windSpeed;
  final int humidity;
  final IconData icon;

  @override
  State<CityWeatherCard> createState() => _StateCityWeatherCard();
}

class _StateCityWeatherCard extends State<CityWeatherCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: cardColor,
      ),
      child: Column(
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

                  // weather
                  Text(
                    widget.weather,
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
                  widget.icon,
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
                    '${widget.windSpeed} m / s',
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
    );
  }
}
