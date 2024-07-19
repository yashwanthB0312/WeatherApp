import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ServiceData{
  final String apikey = '7b90b0eaa07b65a1ff1138de3bb4aa27';

  Future<Map<String, dynamic>> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$apikey'));
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('failed to load data');
    }
  }

  Future<Map<String, dynamic>> fetchWeather() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double lot = position.longitude;
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lot&APPID=$apikey'));
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception('failed to load data');
    }
  }
}