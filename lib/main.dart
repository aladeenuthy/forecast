import 'package:flutter/material.dart';
import 'package:forecast/providers/weather_prov.dart';
import 'package:forecast/screens/home_page.dart';
import 'package:forecast/screens/search_location.dart';
import 'package:forecast/screens/splash_screen.dart';
import 'package:forecast/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      child: const MyApp(), create: (_) => WeatherProvider()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future _fetchWeather;
  @override
  void initState() {
    super.initState();
    _fetchWeather =Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Forecast',
        theme: ThemeData(
            textTheme: ThemeData.light()
                .textTheme
                .apply(bodyColor: Colors.white, displayColor: Colors.white)),
        home: FutureBuilder(
          future: _fetchWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else {
              return const HomePage();
            }
          },
        ),
        routes: {
          SearchLocation.routeName: (context) => const SearchLocation()
        },
        );
  }
}
