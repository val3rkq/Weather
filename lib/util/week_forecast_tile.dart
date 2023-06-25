import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/constants.dart';

class WeekForecastTile extends StatelessWidget {
  WeekForecastTile({
    super.key,
    required this.temperature,
    required this.icon,
    required this.day,
  });

  final int temperature;
  final IconData icon;
  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 110,
      decoration: BoxDecoration(
        color: Color(0x26FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$temperature °С',
            style: GoogleFonts.bebasNeue(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.15,
            ),
          ),
          Icon(
            icon,
            size: 30,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            day,
            style: GoogleFonts.bebasNeue(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
