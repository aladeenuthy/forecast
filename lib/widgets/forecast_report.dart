import 'package:flutter/material.dart';
import 'package:forecast/providers/weather_prov.dart';
import 'package:provider/provider.dart';
import 'package:forecast/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ForecastReport extends StatefulWidget {
  final Function dropShowForecast;
  const ForecastReport({Key? key, required this.dropShowForecast})
      : super(key: key);

  @override
  _ForecastReportState createState() => _ForecastReportState();
}

class _ForecastReportState extends State<ForecastReport> {
  Widget _buldHourlyForecast(String temp, String tempF, String iconUrl, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
              Consumer<WeatherProvider>(
                builder: (context, weatherProv, _) {
                  return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
                  Text(weatherProv.useFarenheit ? tempF: temp, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                  Text(weatherProv.useFarenheit ?  '\u1d52F': '\u1d52C', style: const TextStyle(fontSize: 11),)
            ],
          );
                }
              ),  
          CachedNetworkImage(
              imageUrl: iconUrl,
              height: 40,
              fit: BoxFit.cover,
            ),
          Text(time),
        ],
      ),
    );
  }
  Widget _buildDailyForecast(String date, String iconUrl, String temp, String tempF){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
          Text(date),
          CachedNetworkImage(
              imageUrl: iconUrl,
              height: 30,
              
              fit: BoxFit.cover,
          ),
          Consumer<WeatherProvider>(
            builder: (context, weatherProv, _) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                      weatherProv.useFarenheit ? tempF : temp,
                      style: const TextStyle(
                          fontSize: 15,
                          ),
                    ),
                    Text(
                      weatherProv.useFarenheit ? '\u1d52F': '\u1d52C',
                      style: const TextStyle(fontSize: 11),
                    )
                  ],
                );
            }
          )
        ],),
        
        const Divider()
        
      ]) ,
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherProv = Provider.of<WeatherProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return DefaultTextStyle(
        style: const TextStyle(color: Colors.black),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                widget.dropShowForecast();
              },
              child: Container(
                padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                constraints: const BoxConstraints(maxWidth: 170),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: shaderPrimaryColor,
                ),
                child: Row(children: const [
                  Text(
                    "Forecast report",
                    style: TextStyle(color: primaryColor),
                  ),
                
                  Icon(Icons.keyboard_arrow_down, color: primaryColor)
                ]),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: constraints.maxHeight * 0.2,
                  decoration: BoxDecoration(
                      border: Border.all(color: shaderPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    
                    children: [
                      ...weatherProv.hourlyWeather.map((weather) => _buldHourlyForecast(
                        weather.temp.toString(),
                        weather.tempF,
                        weather.iconUrl,
                        DateFormat('h:mm a')
                                .format(weather.dateTimeObj)
                        )
                      )
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("This weeek's Forecast",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  height: constraints.maxHeight * 0.35,
                  decoration: BoxDecoration(
                      border: Border.all(color: shaderPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView(
                    children: [
                    ...weatherProv.dailyWeather.map((weather) => _buildDailyForecast( DateFormat('MMMM, d').format(weather.dateTimeObj), weather.iconUrl, weather.temp.toString(), weather.tempF))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
