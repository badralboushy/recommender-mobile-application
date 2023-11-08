import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_guide/Models/citymodel.dart';
import 'package:travel_guide/layouts/map.dart';
import 'package:travel_guide/screens/home.dart';
import 'package:travel_guide/screens/login.dart';
import 'package:travel_guide/screens/place.dart';
import 'package:travel_guide/screens/search.dart';
import 'package:travel_guide/screens/signup.dart';
import 'package:travel_guide/screens/welcome.dart';
import 'package:travel_guide/services/location.dart';

import 'layouts/spinner.dart';

void main() async {
 // await Location.getCurrentLocation();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:WelcomePage(),
    )
  );
}
