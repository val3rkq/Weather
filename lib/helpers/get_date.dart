import 'package:intl/intl.dart';

String getDate(int? timezone) {
  DateTime now = DateTime.now().add(Duration(seconds: timezone! - DateTime.now().timeZoneOffset.inSeconds));
  return DateFormat('EEEE, dd MMMM yyyy').format(now);
}

String getTime(int? timezone) {
  DateTime now = DateTime.now().add(Duration(seconds: timezone! - DateTime.now().timeZoneOffset.inSeconds));
  return DateFormat('HH:mm').format(now);
}
