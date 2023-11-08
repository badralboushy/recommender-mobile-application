
import 'package:geolocator/geolocator.dart';

class Location {
 static double? _longitude ;
 // double get longitude => _longitude;
 static double?  _latitude ;
 static bool dataHere = false;



 static Future<void> getCurrentLocation() async {
  LocationPermission perm = await Geolocator.requestPermission();
   if (dataHere )return;
    try {
     Geolocator geolocator =await Geolocator();

     Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
     );
     // final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _latitude = position.latitude;
      _longitude = position.longitude;
      dataHere = true ;
    } catch (e) {
      print(e);
      print("there is an exception in getCurrentLoction:Location");
    }
  }
 static double? get latitude => _latitude;
 static double? get longitude => _longitude;
}
