import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:travel_guide/services/authenticate.dart';

import 'config.dart';

class WeatherApi{

  Future getWeatherData(double? lat,double? long) async {

    int days = 3;
    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com

    
    String API_URL = 'http://${Constants.ServerIP}/api/weathertime/$lat/$long/$days';
    var token = await Authenticate.getToken();
    final response = await http.get(Uri.parse(API_URL),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if( response.statusCode==200){
      final data = json.decode(response.body);
      return data ;
    }else{
      print("response in WeatherTimeApi Response has status code : ${response.statusCode}");

    }

  }
}
