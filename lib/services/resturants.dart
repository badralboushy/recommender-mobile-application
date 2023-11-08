import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:travel_guide/services/authenticate.dart';

import 'config.dart';

class RestaurantsApi{

  Future getRestaurantsData(double? latitude, double? longitude,String kind) async {

    double radius = 10000 ; // meters
    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    String API_URL = 'http://${Constants.ServerIP}/api/restaurants/$latitude/$longitude/$radius';
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();
    final response = await http.get(Uri.parse(API_URL),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      kind : "true",
      'user_id':'$user_id'
    });
    if( response.statusCode == 200){
      final data = json.decode(response.body);
      return data ;
    }
  else{
    print("response in resturant has status code : ${response.statusCode}");
    }
  }
  Future addRestaurantToWishlist(String? placeID,String kind) async {

    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();

    String API_URL = 'http://${Constants.ServerIP}/api/restaurants/love/$user_id/$placeID';

    final response = await http.get(Uri.parse(API_URL),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      kind : "true",
    });
    if( response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }
  }

  Future getRecommendedRestaurantData() async {
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();

    String API_URL = 'http://${Constants.ServerIP}/api/recommendlocationRestaurant/$user_id';

    final response = await http.post(Uri.parse(API_URL),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if( response.statusCode == 200){
      final data = json.decode(response.body);
      return data ;
    }
    else{
      print("response in resturant has status code : ${response.statusCode}");
    }
  }

  Future getLovedRestaurantsData() async {
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();

    String API_URL = 'http://${Constants.ServerIP}/api/getLovedRestaurants/$user_id';

    final response = await http.post(Uri.parse(API_URL),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if( response.statusCode == 200){
      final data = json.decode(response.body);
      return data ;
    }
    else{
      print("response in resturant has status code : ${response.statusCode}");
    }
  }





}
