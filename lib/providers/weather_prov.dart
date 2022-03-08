import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:forecast/utils/services.dart';
import 'package:forecast/models/data.dart';

class WeatherProvider with ChangeNotifier {
  bool _useFarenheit = false;
  Weather? _currentWeather;
  String? _location;
  List<Weather> _hourlyWeather = [];
  List<Weather> _dailyWeather = [];

  bool get useFarenheit {
    return _useFarenheit;
  }

  List<Weather> get hourlyWeather {
    return [..._hourlyWeather];
  }

  List<Weather> get dailyWeather {
    return [..._dailyWeather];
  }

  String get location {
    return _location as String;
  }

  Weather get currentWeather {
    return _currentWeather as Weather;
  }

  void toggleTemp(bool value) {
    _useFarenheit = value;
    notifyListeners();
  }

  List<Weather> _transformHourly(List hourlyData) {
    List<Weather> processedhourlyData = [];
    for (int i = 0; i < hourlyData.length; i++) {
      if (i.isEven) {
        processedhourlyData.add(Weather(
            dateTime: hourlyData[i]['dt'],
            temp: hourlyData[i]['temp'].round(),
            description: hourlyData[i]['weather'][0]['main'],
            icon: hourlyData[i]['weather'][0]['icon']));
      }
    }
    return processedhourlyData;
  }

  List<Weather> _transformDaily(List dailyData) {
    List<Weather> processedDailyData = [];
    processedDailyData = dailyData.map((weather) {
      double temp = (weather['temp']['max'] + weather['temp']['min']) / 2;
      return Weather(
          dateTime: weather['dt'],
          temp: temp.round(),
          description: weather['weather'][0]['main'],
          icon: weather['weather'][0]['icon']);
    }).toList();
    return processedDailyData.sublist(2);
  }

  Future<void> test() async {
    final locationData = await getLocation();
    print(locationData!['lat']);
    print(locationData['long']);
    final url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=${locationData['lat']}&lon=${locationData['long']}&units=metric&exclude=minutely&appid=96865d91a8bef41af266096216d0052d";
    final response = await Dio().get(url);
    print(response.data);
  }

  Future<void> fetchWeather() async {
    final locationData = await getLocation();
    if (locationData == null) {
      return;
    }
    final url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=${locationData['lat']}&lon=${locationData['long']}&units=metric&exclude=minutely&appid=96865d91a8bef41af266096216d0052d";
    final response = await Dio().get(url);
    Map<String, dynamic> responseData = response.data;
    Map<String, dynamic> responseCurrent = responseData['current'];
    double temp = responseCurrent['temp'];
    _currentWeather = Weather(
        dateTime: responseCurrent['dt'],
        temp: temp.round(),
        description: responseCurrent['weather'][0]['main'],
        icon: responseCurrent['weather'][0]['icon']);
    List responseHourly = responseData['hourly'];
    List responseDaily = responseData['daily'];
    _hourlyWeather = _transformHourly(responseHourly.sublist(0, 24));
    _dailyWeather = _transformDaily(responseDaily);
  }

  Future<Map<String, String>?> searchCity(String query) async {
    final url =
        "https://api.openweathermap.org/data/2.5/find?q=$query&units=metric&appid=96865d91a8bef41af266096216d0052d";
    try {
      final response = await Dio().get(url);
      final responseData = response.data;
      if (responseData['cod'] != "200") {
        return null;
      }
      double temp = responseData['list'][0]['main']['temp'];
      return {
        'city_name': responseData['list'][0]['name'] +
            "," +
            responseData['list'][0]['sys']['country'],
        'icon': responseData['list'][0]['weather'][0]['icon'],
        'temp': temp.round().toString(),
        'description': responseData['list'][0]['weather'][0]['main']
      };
    } catch (_) {
      return null;
    }
  }
}
