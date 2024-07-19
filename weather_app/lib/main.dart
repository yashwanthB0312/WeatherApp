import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_1/Services/Service_data.dart';
import 'package:weather_app_1/Widgets/Widget_tile_data.dart';

void main(){
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherAppHome(),
    );
  }
}

class WeatherAppHome extends StatefulWidget {
  const WeatherAppHome({super.key});

  @override
  State<WeatherAppHome> createState() => _WeatherAppHomeState();
}

class _WeatherAppHomeState extends State<WeatherAppHome> {
  TextEditingController _controller = new TextEditingController();
  String _bgImg = 'assets/images/clear.jpg';
  String _iconImg = 'assets/icons/clear.png';
  String _cityName = '';
  String _temp = '';
  String _tempMax = '';
  String _tempMin = '';
  String _sunrise = '';
  String _sunset = '';
  String _main = '';
  String _pressure = '';
  String _humidity = '';
  String _visibility = '';
  String _windSpeed = '';

  Future<Map<String, dynamic>> getData(String cityName) async{
    final weatherService = ServiceData();
    var weatherData;
    if(cityName == ''){
      weatherData = await weatherService.fetchWeather();
    }else{
      weatherData = await weatherService.getWeather(cityName);
    }
    debugPrint(weatherData.toString());
    setState(() {
      _cityName = weatherData['name'];
      _temp = weatherData['main']['temp'].toStringAsFixed(1);
      _main = weatherData['weather'][0]['main'];
      _tempMax = weatherData['main']['temp_max'].toStringAsFixed(1);
      _tempMin = weatherData['main']['temp_min'].toStringAsFixed(1);
      _sunrise = DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunrise'] * 1000));
      _sunset = DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunset'] * 1000));
      _pressure = weatherData['main']['pressure'].toString();
      _humidity = weatherData['main']['humidity'].toString();
      _visibility = weatherData['visibility'].toString();
      _windSpeed = weatherData['wind']['speed'].toString();
      if (_main == 'Clear') {
        _bgImg = 'assets/images/clear.jpg';
        _iconImg = 'assets/icons/Clear.png';
      } else if (_main == 'Clouds') {
        _bgImg = 'assets/images/clouds.jpg';
        _iconImg = 'assets/icons/Clouds.png';
      } else if (_main == 'Rain') {
        _bgImg = 'assets/images/rain.jpg';
        _iconImg = 'assets/icons/Rain.png';
      } else if (_main == 'Fog') {
        _bgImg = 'assets/images/fog.jpg';
        _iconImg = 'assets/icons/Haze.png';
      } else if (_main == 'Thunderstorm') {
        _bgImg = 'assets/images/thunderstorm.jpg';
        _iconImg = 'assets/icons/Thunderstorm.png';
      } else {
        _bgImg = 'assets/images/haze.jpg';
        _iconImg = 'assets/icons/Haze.png';
      }
    });
    return weatherData;
  }

  Future<bool> _checkLocationPermission() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return false;
      }
      getData('');
    }
    getData('');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(_bgImg,fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
          Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  TextField(
                    controller: _controller,
                    onChanged: (value){
                      setState(() {
                        getData(value);
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Enter the city',
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined),
                      Text(
                        _cityName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "$_temp°c",
                    style: TextStyle(
                      fontSize: 75,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _main,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Image.asset(_iconImg),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_upward_outlined),
                      Text(
                        "$_tempMax°c",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_downward_outlined),
                      Text(
                        "$_tempMin°c",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Card(
                    color: Colors.black12,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          WidgetTileData(index1: 'Sunrise', index2: 'Sunset', value1: _sunrise, value2: _sunset),
                          SizedBox(height: 15,),
                          WidgetTileData(index1: 'Pressure', index2: 'Humidity', value1: _visibility, value2: _humidity),
                          SizedBox(height: 15,),
                          WidgetTileData(index1: 'Visibility', index2: 'Wind speed', value1: _pressure, value2: _windSpeed),
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


