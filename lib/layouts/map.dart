import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:travel_guide/Models/placemodel.dart';
import 'package:travel_guide/layouts/spinner.dart';
import 'package:travel_guide/screens/place.dart';
import 'package:travel_guide/screens/search.dart';

class MapWidget extends StatefulWidget {
  double? lat;
  double? long;
  String? kind;
  List<PlaceModel> places = <PlaceModel>[];
  MapWidget(double? lt, double? ln , List<PlaceModel> pl , String k) {
    this.lat = lt;
    this.long = ln;
    places = pl ;
    this.kind =k;
  }

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  void initState() {
    // TODO: implement initState
    setMarkers();
    super.initState();
  }

  Set<Marker> Markers = Set<Marker>();

  Future setMarkers() async{
    int num = 0;
    for (var item in widget.places) {
      bool hotel = false;
      if (item.type=='hotel') {hotel = true;}
      Markers.add(Marker(
        markerId: MarkerId('$num'),
        position: LatLng(item.latitude, item.longitude),
        infoWindow: InfoWindow(
          title: item.name,
          onTap: () {
            Alert(
                context: context,
                content: Container(
                  width: 300,
                  height: 300,

                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: SearchPage.getImage(item.photoUrl,item.type),
                        fit: BoxFit.fill,
                  )),
                ),

                buttons: [
                  DialogButton(
                      child: Text('Details'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlacePage(item,widget.kind)));
                      }),
                  DialogButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]).show();
          },
        ),
        icon:(hotel==true)? BitmapDescriptor.defaultMarker : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

      ));
      num++;

    }
  setState(() {

  });
  // showMap();
  }


  showMap() {
    if (widget.long == null || widget.lat == null) {
      return SpinnerWidget(120);
    } else {
      return GoogleMap(
          markers:Markers,
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat!, widget.long!),
              zoom: 13,
              bearing: 45,
              tilt: 45),
          mapType: MapType.normal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 165,
      child: showMap(),
    );
  }
}
