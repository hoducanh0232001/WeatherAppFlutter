import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learncross/components/weather_item.dart';
import 'package:learncross/models/constants.dart';

class DetailPage extends StatefulWidget {
  final dailyForeCastWeather;

  const DetailPage({super.key, required this.dailyForeCastWeather});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Constants _constants = Constants();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var weatherData = widget.dailyForeCastWeather;

//func get forecast weather
    Map getForecastWeather(int index) {
      int maxWindSpeed = weatherData[index]["day"]["maxwind_kph"].toInt();
      int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt();
      int chanceOfRain =
          weatherData[index]["day"]["daily_chance_of_rain"].toInt();

      var parsedDate = DateTime.parse(weatherData[index]["date"]);
      var forecastDate = DateFormat('EEEE, d MMMM').format(parsedDate);

      String weatherName = weatherData[index]["day"]["condition"]["text"];
      String weatherIcon =
          "${weatherName.replaceAll(' ', '').toLowerCase()}.png";

      int minTemperature = weatherData[index]["day"]["mintemp_c"].toInt();
      int maxTemperature = weatherData[index]["day"]["maxtemp_c"].toInt();

      var forecastData = {
        'maxWindSpeed': maxWindSpeed,
        'avgHumidity': avgHumidity,
        'chanceOfRain': chanceOfRain,
        'forecastDate': forecastDate,
        'weatherName': weatherName,
        'weatherIcon': weatherIcon,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature
      };
      return forecastData;
    }

    return Scaffold(
      backgroundColor: _constants.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: _constants.primaryColor,
        title: const Text(
          'Forecast',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => {print('settings tapped')},
              icon: Icon(Icons.settings),
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .75,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      top: -50,
                      right: 20,
                      left: 20,
                      child: Container(
                        height: 300,
                        width: size.width * .7,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5),
                              ]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.1),
                              offset: const Offset(0, 25),
                              blurRadius: 3,
                              spreadRadius: -10,
                            )
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              child: Image.asset("assets/" +
                                  getForecastWeather(0)["weatherIcon"]),
                              width: 150,
                            ),
                            Positioned(
                                top: 150,
                                left: 30,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    getForecastWeather(0)["weatherName"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )),
                            Positioned(
                              bottom: 10,
                              left: 20,
                              child: Container(
                                width: size.width * .8,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    WeatherItem(
                                      text: 'Wind Speed',
                                      value:
                                          getForecastWeather(0)["maxWindSpeed"],
                                      unit: "km/h",
                                      imageUrl: "assets/windspeed.png",
                                    ),
                                    WeatherItem(
                                      text: 'Humidity',
                                      value:
                                          getForecastWeather(0)["avgHumidity"],
                                      unit: "%",
                                      imageUrl: "assets/humidity.png",
                                    ),
                                    WeatherItem(
                                      text: 'Chance Of Rain',
                                      value:
                                          getForecastWeather(0)["chanceOfRain"],
                                      unit: "%",
                                      imageUrl: "assets/lightrain.png",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getForecastWeather(0)["maxTemperature"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = _constants.shader,
                                    ),
                                  ),
                                  Text(
                                    'o',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      foreground: Paint()
                                        ..shader = _constants.shader,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    top: 270,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                      height: 400,
                      width: size.width * .9,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(getForecastWeather(0)["forecastDate"], style:const TextStyle(
                                        color: Color(0xff6696f5),
                                        fontWeight: FontWeight.w600,

                                      ),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(getForecastWeather(0)["minTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              Text(getForecastWeather(0)["maxTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/' + getForecastWeather(0)["weatherIcon"],width: 30,),
                                          const SizedBox(width: 5,),
                                          Text(getForecastWeather(0)["weatherName"], style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(getForecastWeather(0)["chanceOfRain"].toString() + "%", style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),),
                                          const SizedBox(width: 5,),
                                          Image.asset('assets/lightrain.png',width: 30,),
                                        ],
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(getForecastWeather(1)["forecastDate"], style:const TextStyle(
                                        color: Color(0xff6696f5),
                                        fontWeight: FontWeight.w600,

                                      ),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(getForecastWeather(1)["minTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              Text(getForecastWeather(1)["maxTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/' + getForecastWeather(1)["weatherIcon"],width: 30,),
                                          const SizedBox(width: 5,),
                                          Text(getForecastWeather(1)["weatherName"], style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(getForecastWeather(1)["chanceOfRain"].toString() + "%", style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),),
                                          const SizedBox(width: 5,),
                                          Image.asset('assets/lightrain.png',width: 30,),
                                        ],
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(getForecastWeather(2)["forecastDate"], style:const TextStyle(
                                        color: Color(0xff6696f5),
                                        fontWeight: FontWeight.w600,

                                      ),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(getForecastWeather(2)["minTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              Text(getForecastWeather(2)["maxTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/' + getForecastWeather(2)["weatherIcon"],width: 30,),
                                          const SizedBox(width: 5,),
                                          Text(getForecastWeather(2)["weatherName"], style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(getForecastWeather(2)["chanceOfRain"].toString() + "%", style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),),
                                          const SizedBox(width: 5,),
                                          Image.asset('assets/lightrain.png',width: 30,),
                                        ],
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(getForecastWeather(3)["forecastDate"], style:const TextStyle(
                                        color: Color(0xff6696f5),
                                        fontWeight: FontWeight.w600,

                                      ),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(getForecastWeather(3)["minTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              Text(getForecastWeather(3)["maxTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/' + getForecastWeather(3)["weatherIcon"],width: 30,),
                                          const SizedBox(width: 5,),
                                          Text(getForecastWeather(3)["weatherName"], style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(getForecastWeather(3)["chanceOfRain"].toString() + "%", style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),),
                                          const SizedBox(width: 5,),
                                          Image.asset('assets/lightrain.png',width: 30,),
                                        ],
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(getForecastWeather(4)["forecastDate"], style:const TextStyle(
                                        color: Color(0xff6696f5),
                                        fontWeight: FontWeight.w600,

                                      ),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(getForecastWeather(4)["minTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              Text(getForecastWeather(4)["maxTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/' + getForecastWeather(4)["weatherIcon"],width: 30,),
                                          const SizedBox(width: 5,),
                                          Text(getForecastWeather(4)["weatherName"], style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(getForecastWeather(4)["chanceOfRain"].toString() + "%", style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),),
                                          const SizedBox(width: 5,),
                                          Image.asset('assets/lightrain.png',width: 30,),
                                        ],
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(getForecastWeather(5)["forecastDate"], style:const TextStyle(
                                        color: Color(0xff6696f5),
                                        fontWeight: FontWeight.w600,

                                      ),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(getForecastWeather(5)["minTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              Text(getForecastWeather(5)["maxTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/' + getForecastWeather(5)["weatherIcon"],width: 30,),
                                          const SizedBox(width: 5,),
                                          Text(getForecastWeather(5)["weatherName"], style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(getForecastWeather(5)["chanceOfRain"].toString() + "%", style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),),
                                          const SizedBox(width: 5,),
                                          Image.asset('assets/lightrain.png',width: 30,),
                                        ],
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(getForecastWeather(4)["forecastDate"], style:const TextStyle(
                                        color: Color(0xff6696f5),
                                        fontWeight: FontWeight.w600,

                                      ),),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(getForecastWeather(6)["minTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.greyColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                          const SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              Text(getForecastWeather(6)["maxTemperature"].toString(),
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                ),),
                                              Text('o',
                                                style: TextStyle(
                                                  color: _constants.blackColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  fontFeatures:const [FontFeature.enable('sups')],
                                                ),),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/' + getForecastWeather(6)["weatherIcon"],width: 30,),
                                          const SizedBox(width: 5,),
                                          Text(getForecastWeather(6)["weatherName"], style:const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(getForecastWeather(6)["chanceOfRain"].toString() + "%", style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),),
                                          const SizedBox(width: 5,),
                                          Image.asset('assets/lightrain.png',width: 30,),
                                        ],
                                      ),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
