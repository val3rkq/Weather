import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/constants.dart';

class DayForecastTile extends StatelessWidget {
  DayForecastTile({
    super.key,
    required this.temperature,
    required this.time,
    required this.icon,
    required this.unit,
  });

  final int temperature;
  final String time;
  final IconData icon;
  final String unit;

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
            '$temperature $unit',
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
            time,
            style: GoogleFonts.bebasNeue(
              fontSize: 18,
              letterSpacing: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}
