import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    Key? key,
    this.onTap,
    required this.item,
    required this.itemDesc,
    required this.icon,
  }) : super(key: key);

  final Function()? onTap;
  final String item;
  final String itemDesc;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF29282C),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 25,
                  ),
                ),
                Text(
                  itemDesc,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            Icon(
              icon,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
