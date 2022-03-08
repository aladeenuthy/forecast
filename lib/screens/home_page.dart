import 'package:flutter/material.dart';
import 'package:forecast/providers/weather_prov.dart';
import 'package:forecast/screens/search_location.dart';
import 'package:forecast/utils/colors.dart';
import 'package:forecast/widgets/forecast_report.dart';
import 'package:forecast/widgets/weather_box.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showForecastReport = false;
  void dropShowForecast() {
    setState(() {
      showForecastReport = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWeather =
        Provider.of<WeatherProvider>(context, listen: false).currentWeather;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Stack(children: [
              Container(
                width: constraints.maxWidth,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Abuja, NG",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: shadePrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        Container(
                            decoration: BoxDecoration(
                                color: shadePrimaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(SearchLocation.routeName);
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ))),
                      ],
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.03,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.2,
                      decoration: BoxDecoration(
                          color: shadePrimaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.04,
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(right: 10, bottom: 17),
                      height: constraints.maxHeight * 0.47,
                      decoration: BoxDecoration(
                          color: shadePrimaryColor,
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: const WeatherBox(),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showForecastReport = true;
                        });
                      },
                      child: Container(
                        height: constraints.maxHeight * 0.1,
                        decoration: BoxDecoration(
                            color: shadePrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Forecast report"),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(Icons.keyboard_arrow_up, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                top: showForecastReport
                    ? constraints.maxHeight * 0.1
                    : constraints.maxHeight * 1.5,
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: ForecastReport(
                    dropShowForecast: dropShowForecast,
                  ),
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticInOut,
              )
            ]),
          );
        }),
      ),
    );
  }
}
