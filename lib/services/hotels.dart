import 'dart:convert';
import 'package:travel_guide/services/authenticate.dart';
import 'package:travel_guide/services/location.dart';
import 'package:http/http.dart' as http;

import 'config.dart';


class HotelsApi{

  Future getHotelsData(double? latitude,double? longitude,String kind) async {
    double radius = 5000 ; // meters
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();
    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    String API_URL = 'http://${Constants.ServerIP}/api/hotels/$latitude/$longitude/$radius';
    final response = await http.get(Uri.parse(API_URL),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
       kind:'true',
      'user_id':'$user_id'
    });
    if( response.statusCode == 200){
        final data = json.decode(response.body);
        return data ;
      }else {
        print("response in HotelsApi has status code : ${response.statusCode}");
      }

  }

  Future addHotelToWishlist(String? placeID,String kind) async {

    //192.168.98.159:9000
    //https://phplaravel-646900-2109243.cloudwaysapps.com
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();

    String API_URL = 'http://${Constants.ServerIP}/api/hotels/love/$user_id/$placeID';

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

  Future getRecommendedHotelsData() async {
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();

    String API_URL = 'http://${Constants.ServerIP}/api/recommendlocationHotel/$user_id';

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
      print("response in Hotel has status code : ${response.statusCode}");
    }
  }
  Future getLovedHotelsData() async {
    var token = await Authenticate.getToken();
    var user_id = await Authenticate.getUser_id();

    String API_URL = 'http://${Constants.ServerIP}/api/getLovedHotels/$user_id';

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
