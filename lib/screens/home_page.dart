import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forecast/providers/weather_prov.dart';
import 'package:forecast/screens/map_screen.dart';
import 'package:forecast/screens/search_location.dart';
import 'package:forecast/utils/colors.dart';
import 'package:forecast/utils/services.dart';
import 'package:forecast/widgets/forecast_report.dart';
import 'package:forecast/widgets/weather_box.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final bool hasError;
  const HomePage({Key? key, this.hasError = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.hasError) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No internet connection')));
      });
    }
  }

  bool showForecastReport = false;
  void dropShowForecast() {
    setState(() {
      showForecastReport = false;
    });
  }

  Future<void> _pullRefresh() async {
    try {
      await Provider.of<WeatherProvider>(context, listen: false).fetchWeather();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection')));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProv = Provider.of<WeatherProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          backgroundColor: Colors.black,
          color: primaryColor,
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                              label: Text(
                                weatherProv.address,
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: shadePrimaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)))),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => MapScreen(
                                lat: weatherProv.location['lat'] as double,
                                long: weatherProv.location['long'] as double),
                          ));
                        },
                        child: Container(
                          height: constraints.maxHeight * 0.2,
                          decoration: BoxDecoration(
                              color: shadePrimaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                imageUrl: generateLocationPreviewImage(
                                    weatherProv.location['lat'],
                                    weatherProv.location['long']),
                                width: double.infinity,
                                fit: BoxFit.cover),
                          ),
                        ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }
}
