import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/model/db_model.dart';
import 'package:weather_app/model/weather_model.dart';

class MakeFavouriteCity extends StatefulWidget {
  MakeFavouriteCity({
    super.key,
    required this.db,
    required this.dataNow,
  });

  DB db = DB();
  Weather? dataNow;

  @override
  State<MakeFavouriteCity> createState() => _MakeFavouriteCityState();
}

class _MakeFavouriteCityState extends State<MakeFavouriteCity> {
  void onFavIconTap() {
    setState(() {
      if (widget.db.favourites!.contains(widget.dataNow!.cityName!)) {
        widget.db.favourites!.remove(widget.dataNow!.cityName!);
      } else {
        widget.db.favourites!.add(widget.dataNow!.cityName!);
      }
      widget.db.updateDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        // check, is there this city in favourites
        widget.db.favourites!.contains(widget.dataNow!.cityName!)
            ? CupertinoIcons.heart_fill
            : CupertinoIcons.heart,
        size: 30,
      ),
      onTap: () {
        onFavIconTap();
      },
    );
  }
}
