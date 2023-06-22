import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

IconData getIcon(String condition) {
  switch (condition.toLowerCase()) {
    case 'rain':
      return CupertinoIcons.cloud_rain_fill;
    case 'clear':
      return Icons.wb_sunny;
    case 'clouds':
      return CupertinoIcons.cloud_fill;
    case 'snow':
      return CupertinoIcons.snow;
    case 'thunderstorm':
      return Icons.thunderstorm_rounded;
    default:
      return CupertinoIcons.cloud_fill;
  }
}