import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:forecast/utils/services.dart';
import 'package:forecast/models/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  bool _useFarenheit = false;
  Weather? _currentWeather;
  Map<String, double>? _location;
  String? _address;
  List<Weather> _hourlyWeather = [];
  List<Weather> _dailyWeather = [];

  bool get useFarenheit {
    return _useFarenheit;
  }

  String get address {
    return _address ?? "";
  }

  List<Weather> get hourlyWeather {
    return [..._hourlyWeather];
  }

  List<Weather> get dailyWeather {
    return [..._dailyWeather];
  }

  Map<String, double> get location {
    return _location ?? {};
  }

  Weather get currentWeather {
    return _currentWeather as Weather;
  }

  void toggleTemp(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _useFarenheit = value;
    prefs.setBool('useFarenheit', _useFarenheit);
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
    return processedDailyData.sublist(1);
  }

  Future<void> setStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> currentData =
        json.decode(prefs.getString('currentWeather') ?? "");
    _currentWeather = Weather(
        dateTime: currentData['dateTime'],
        temp: currentData['temp'],
        description: currentData['description'],
        icon: currentData['icon']);
    _useFarenheit = prefs.getBool('useFarenheit') ?? false;
    _address = prefs.getString('address');
  }

  Future<void> fetchWeather() async {
    final locationData = await getLocation();
    if (locationData == null ) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    // store latitude and  longitude
    _location = locationData;

    _useFarenheit = prefs.getBool('useFarenheit') ?? false;
    final isConnected = await isConnectedToInternet();
    if (!isConnected) {
      await setStoredData();
      throw Exception();
    }
    try {
      // open weather one call  api
      final url =
          "https://api.openweathermap.org/data/2.5/onecall?lat=${locationData['lat'].toString()}&lon=${locationData['long'].toString()}&units=metric&exclude=minutely&appid=96865d91a8bef41af266096216d0052d";

      final response = await Dio().get(url);
      // get address from latitude and longitude
      _address = await getAddress(
          locationData['lat'].toString(), locationData['long'].toString());

      // Filter api response
      Map<String, dynamic> responseData = response.data;
      Map<String, dynamic> responseCurrent = responseData['current'];
      double temp = responseCurrent['temp'];
      // store current weather
      _currentWeather = Weather(
          dateTime: responseCurrent['dt'],
          temp: temp.round(),
          description: responseCurrent['weather'][0]['main'],
          icon: responseCurrent['weather'][0]['icon']);
      // storing data in phone storage incase there's no internet connection
      prefs.setString(
          'currentWeather',
          json.encode({
            'dateTime': _currentWeather!.dateTime,
            'temp': _currentWeather!.temp,
            'description': _currentWeather!.description,
            'icon': _currentWeather!.icon
          }));
      prefs.setString('address', _address as String);
      prefs.setBool('useFarenheit', useFarenheit);

      List responseHourly = responseData['hourly'];
      List responseDaily = responseData['daily'];

      // store hourly  and daily weather
      _hourlyWeather = _transformHourly(responseHourly.sublist(0, 24));
      _dailyWeather = _transformDaily(responseDaily);
    } catch (error) {
      await setStoredData();
      throw Exception();
    }
  }

  Future<Map<String, String>?> searchCity(String query) async {
    // query city
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
