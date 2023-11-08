import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:travel_guide/services/authenticate.dart';

import 'config.dart';

class Similar_PlacesApi{

  Future getSimilarRestaurantsData(String? searchOrLocation, String? placeID) async {

    var user_id =await Authenticate.getUser_id();
    var token = await Authenticate.getToken();
    String kind = searchOrLocation!;
      String API_URL = 'http://${Constants.ServerIP}/api/recommendRestaurant/$user_id/$placeID';
      final response = await http.post(Uri.parse(API_URL),headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
          kind:'true',
        'Authorization': 'Bearer $token',
      });
      if( response.statusCode == 200){
        final data = json.decode(response.body);
        print(data);
        return data ;
      }
      else{
        print("response in resturant has status code : ${response.statusCode}");
      }

    }

  Future getSimilarHotelsData(String? searchOrLocation, String? placeID) async {

    var user_id =await Authenticate.getUser_id();
    var token = await Authenticate.getToken();
    String kind = searchOrLocation!;
    String API_URL = 'http://${Constants.ServerIP}/api/recommendHotel/$user_id/$placeID';
    final response = await http.post(Uri.parse(API_URL),headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      kind:'true',
      'Authorization': 'Bearer $token',
    });
    if( response.statusCode == 200){
      final data = json.decode(response.body);
      print(data);
      return data ;
    }
    else{
      print("response in hotel has status code : ${response.statusCode}");
    }

  }



  }
