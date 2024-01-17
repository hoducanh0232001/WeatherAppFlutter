import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:learncross/components/weather_item.dart';
import 'package:learncross/models/constants.dart';
import 'package:learncross/models/city.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static String API_KEY = "0e1ad3723bf7442283293450241601";
  TextEditingController _cityControler = TextEditingController();

  // API call
  String searchWeatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=" +
      API_KEY +
      "&days7&q=";
  Constants myConstants = Constants();
  int temperature = 0;
  int maxTemp = 0;
  int cloud = 0;
  String weather = 'Loading...';
  int humidity = 0;
  int windSpeed = 0;
  var currentDate = '';
  int woeid = 44418; // where on earth id for London
  String location = 'Vietnam';
  String weatherIcon = 'Loading...';
  String currentWeatherStatus = 'Loading...';

  var selectedCities = City.getSelectedCities();
  List<String> cities = ['London'];
  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  void fetchDataWeather(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));
      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');
      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];
      setState(() {
        location = getShortLocationName(locationData["name"]);
        var parseDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parseDate);
        currentDate = newDate;
        print(currentDate);
        // update weather
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        // forecast date
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        print(dailyWeatherForecast);
      });
    } catch (e) {}
  }

  //func to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");
    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchDataWeather(location);
    super.initState();
  }

  //Create a shader linear gradient
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        color: myConstants.primaryColor.withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: size.height * .65,
              decoration: BoxDecoration(
                gradient: myConstants.linearGradientBlue,
                boxShadow: [
                  BoxShadow(
                    color: myConstants.primaryColor.withOpacity(.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/menu.png",
                        width: 40,
                        height: 40,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/pin.png",
                            width: 20,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _cityControler.clear();
                              showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                        controller:
                                            ModalScrollController.of(context),
                                        child: Container(
                                          height: size.height * .2,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 70,
                                                child: Divider(
                                                  thickness: 3.5,
                                                  color:
                                                      myConstants.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                onChanged: (searchText) {
                                                  fetchDataWeather(searchText);
                                                },
                                                controller: _cityControler,
                                                autofocus: true,
                                                decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.search,
                                                      color: myConstants
                                                          .primaryColor,
                                                    ),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () =>
                                                          _cityControler
                                                              .clear(),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: myConstants
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    hintText:
                                                        'Search your city',
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: myConstants
                                                            .primaryColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/profile.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: Image.asset("assets/" + weatherIcon),
                    width: double.infinity,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = myConstants.shader),
                          )),
                      Text(
                        'o',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = myConstants.shader,
                        ),
                      )
                    ],
                  ),
                  Text(
                    currentWeatherStatus,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    currentDate,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: const Divider(
                      color: Colors.white70,
                    ),
                  ),
                  Container(
                    padding:const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WeatherItem(
                          value: windSpeed.toInt(),
                          unit: 'km/h',
                          imageUrl: 'assets/windspeed.png',
                        ),
                        WeatherItem(
                          value: humidity.toInt(),
                          unit: '%',
                          imageUrl: 'assets/humidity.png',
                        ),
                        WeatherItem(
                          value: cloud.toInt(),
                          unit: '%',
                          imageUrl: 'assets/cloud.png',
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              height: size.height * .2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Today', style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                      GestureDetector(
                        onTap: () => ' tapped',
                        child: Text('Forecast', style: TextStyle(
                          color: myConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),),
                      )
                    ],
                  ),
                  const SizedBox(height: 8,),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                        String currentHours = currentTime.substring(0,2);
                        String forecastTime = hourlyWeatherForecast[index]["time"].substring(11,16);
                        String forecastHour = hourlyWeatherForecast[index]["time"].substring(11,13);
                        String forecastWeatherName = hourlyWeatherForecast[index]["condition"]["text"];
                        String forecastWeatherIcon = "${forecastWeatherName.replaceAll(' ', '').toLowerCase()}.png";
                        String forecastTemperature = hourlyWeatherForecast[index]["temp_c"].round().toString();
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(right: 20),
                          width: 65,
                          decoration: BoxDecoration(
                            color: currentHours == forecastHour ? Colors.white : myConstants.primaryColor,
                            borderRadius:const BorderRadius.all(Radius.circular(50)),
                            boxShadow: [BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: myConstants.primaryColor.withOpacity(.2),
                            )],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(forecastTime, style: TextStyle(
                                fontSize: 17,
                                color: myConstants.greyColor,
                                fontWeight: FontWeight.w500,
                              ),),
                              Image.asset('assets/' + forecastWeatherIcon, width: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(forecastTemperature, style: TextStyle(
                                    color: myConstants.greyColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),),
                                  Text('o',style: TextStyle(
                                    color: myConstants.greyColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const[
                                      FontFeature.enable('sups')
                                    ],
                                  ),)
                                ],
                              )
                            ],
                          ),
                        );

                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


