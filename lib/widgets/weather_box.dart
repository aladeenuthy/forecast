import 'package:cached_network_image/cached_network_image.dart';
import 'package:forecast/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forecast/providers/weather_prov.dart';
import 'package:intl/intl.dart';

class WeatherBox extends StatefulWidget {
  const WeatherBox({Key? key}) : super(key: key);

  @override
  _WeatherBoxState createState() => _WeatherBoxState();
}

class _WeatherBoxState extends State<WeatherBox> {
  @override
  Widget build(BuildContext context) {
  final weatherProv =
        Provider.of<WeatherProvider>(context, listen: false);
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Switch(
              value: weatherProv.useFarenheit,
              onChanged: (value) {
                weatherProv.toggleTemp(value);
              },
              activeColor: primaryColor,
            ),
            const SizedBox(
              width: 2,
            ),
            const Text(
              "F",
              style: TextStyle(fontSize: 19),
            )
          ],
        );
      }),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: weatherProv.currentWeather.iconUrl,
            width: 50,
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(DateFormat('EEE d/M/y').format(weatherProv.currentWeather.dateTimeObj))
            ],
          )
        ],
      ),
      Consumer<WeatherProvider>(
        builder: (context, weatherProv, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              weatherProv.useFarenheit ? weatherProv.currentWeather.tempF: weatherProv.currentWeather.temp.toString(),
                style: const TextStyle(
                  fontSize: 110,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  weatherProv.useFarenheit ? '\u1d52F' : '\u1d52C',
                  style:const TextStyle(fontSize: 20),
                ),
              )
            ],
          );
        }
      ),
      Text(
          weatherProv.address + ", " + DateFormat('h:mm a').format(weatherProv.currentWeather.dateTimeObj),
          style: const TextStyle(fontSize: 16))
    ]);
  }
}
