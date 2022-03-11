import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forecast/providers/weather_prov.dart';
import 'package:forecast/utils/colors.dart';
import 'package:provider/provider.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({Key? key}) : super(key: key);
  static const routeName = "/search";

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  Map<String, String>? searchResult;
  final _controller = TextEditingController();
  bool isLoading = false;
  void _search(String value) async {
    if (_controller.text.isEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    final result = await Provider.of<WeatherProvider>(context, listen: false)
        .searchCity(_controller.text);
    if (result == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("City not found")));
      setState(() {
        searchResult = null;
        isLoading = false;
      });
      return;
    }

    setState(() {
      searchResult = result;
      isLoading = false;
      _controller.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Search"),
            backgroundColor: primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Search city",
                        suffixIcon: isLoading
                            ? Transform.scale(
                                scale: 0.5,
                                child: const CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Icon(Icons.search)),
                    onSubmitted: _search,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  if (searchResult != null)
                    Container(
                      height: 90,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(children: [
                        CachedNetworkImage(
                          imageUrl:
                              'http://openweathermap.org/img/w/${searchResult!['icon']}.png',
                          width: 60,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              searchResult!['city_name'] as String ,
                              softWrap: true,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchResult!['temp'] as String,
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                                const Text(
                                  '\u1d52C',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black),
                                )
                              ],
                            ),
                            Text(searchResult!['description'] as String,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.black))
                          ],
                        )
                      ]),
                    )
                ],
              ),
            );
          })),
    );
  }
}
