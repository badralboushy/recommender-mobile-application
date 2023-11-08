import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_guide/Models/citymodel.dart';
import 'package:dio/dio.dart';
import 'package:travel_guide/services/authenticate.dart';

import 'config.dart';

class AutoCompleteApi {
  static Future<List<CityModel>> getSuggestedCities(String query) async {
    if (query.isEmpty) {
      final List<CityModel> data = [];

      return data;
    }
    var token = await Authenticate.getToken();
    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    String API_URL = 'http://${Constants.ServerIP}/api/cityAutoComplete/';
    var response = await http.get(Uri.parse(API_URL + query),headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200){
      final data = json.decode(response.body);
      List<CityModel> result = [];

      for (var item in data['data']) {
        CityModel temp = CityModel(item['cityName'], item['countryName'],
            item['latitude'], item['longitude']);
        result.add(temp);

      }
      return result;
    } else {
    return [] ;
    }
  }
}
