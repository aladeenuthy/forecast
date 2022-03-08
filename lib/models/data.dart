import 'package:intl/intl.dart';

class Weather {
  final int dateTime;
  final int temp;
  final String description;
  final String icon;
  Weather(
      {required this.dateTime,
      required this.temp,
      required this.description,
      required this.icon});

  String get iconUrl {
    return 'http://openweathermap.org/img/w/$icon.png';
  }

  String get tempF {
    double t = (temp * 9 / 5) + 32;
    return t.round().toString();
  }

  DateTime get dateTimeObj {
    return DateTime.fromMillisecondsSinceEpoch(dateTime * 1000);
  }

}
