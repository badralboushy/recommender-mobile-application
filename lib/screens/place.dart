import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/Models/placemodel.dart';
import 'package:travel_guide/layouts/map.dart';
import 'package:travel_guide/layouts/spinner.dart';
import 'package:travel_guide/screens/search.dart';
import 'package:travel_guide/services/Similar_Places.dart';
import 'package:travel_guide/services/authenticate.dart';
import 'package:travel_guide/services/hotels.dart';
import 'package:travel_guide/services/resturants.dart';

class PlacePage extends StatefulWidget {
  PlaceModel placeInfo;
  String? kind;

  PlacePage(this.placeInfo, this.kind);

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  void initState() {
    super.initState();

    getRecommendedData();
  }

  void getRecommendedData() {
    if (widget.placeInfo.type == 'restaurant') {
      getRecommendedRestaurants();
    } else {
      getRecommendedHotels();
    }
  }

  List<Widget> showMap() {
    return [
      Text(
        'Map',
        style: TextStyle(
            fontWeight: FontWeight.w900, fontSize: 18),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
          height: MediaQuery.of(context).size.height / 4,
          child: MapWidget(widget.placeInfo.latitude,
              widget.placeInfo.longitude, [widget.placeInfo], widget.kind!))
    ];
  }

  List<Widget> recommendedRestaurants = [];
  List<Widget> recommendedHotels = [];
  bool restRecommendationIsDone = false;
  bool hotelRecommendationIsDone = false;
  bool mapViewIsPressed = false;
  Color heartColor = Colors.white;
  Color mapIconColor= Colors.white;

  Future getRecommendedRestaurants() async {
    //TODO implement getRecommendedPlaces
    var recommenderApi = Similar_PlacesApi();
    var data = await recommenderApi.getSimilarRestaurantsData(
        widget.kind, widget.placeInfo.place_id);
    print(data);
    for (var item in data['data']) {
      PlaceModel? temp;
      if ((item['longitude'] != 'NONE') && (item['latitude'] != 'NONE')) {
        print(item['price']);
        temp = PlaceModel(
            item['location_id'],
            widget.placeInfo.type,
            item['name'],
            item['description'],
            item['rating'],
            item['address'][0],
            item['phone'],
            item['photo'],
            double.parse(item['latitude']),
            double.parse(item['longitude']),
        // item['price']
        );
      }
      recommendedRestaurants.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlacePage(temp!, widget.kind)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 160.0,
              height: 170,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              // padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: SearchPage.getImage(item['photo'], 'restaurant'),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFF023047),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            Column(children: [
              Container(
                width: 160,
                child: Center(
                  child: Text(
                    item['name'] == 'NONE'
                        ? 'No name is Available'
                        : item['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Rating: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item['rating'] == 'NONE' ? 'no rating' : item['rating'],
                  ),
                ],
              ),
            ])
          ],
        ),
      ));
    }
    setState(() {
      restRecommendationIsDone = true;
    });
  }

  Future getRecommendedHotels() async {
    //TODO implement getRecommendedPlaces
    var recommenderApi = Similar_PlacesApi();
    var data = await recommenderApi.getSimilarHotelsData(
        widget.kind, widget.placeInfo.place_id);
    //print(data);
    for (var item in data['data']) {
      PlaceModel? temp;
      if ((item['longitude'] != 'NONE') && (item['latitude'] != 'NONE')) {
        temp = PlaceModel(
            item['location_id'],
            widget.placeInfo.type,
            item['name'],
            item['description'],
            item['rating'],
            item['address'][0],
            item['phone'],
            item['photo'],
            item['latitude'],
            item['longitude'],
        // item['price']
        );
      }
      recommendedHotels.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlacePage(temp!, widget.kind)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 160.0,
              height: 170,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              // padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: SearchPage.getImage(item['photo'], 'restaurant'),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFF023047),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            Column(children: [
              Container(
                width: 160,
                child: Center(
                  child: Text(
                    item['name'] == 'NONE'
                        ? 'No name is Available'
                        : item['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Rating: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item['rating'] == 'NONE' ? 'no rating' : item['rating'],
                  ),
                ],
              ),
            ])
          ],
        ),
      ));
    }
    setState(() {
      hotelRecommendationIsDone = true;
    });
  }

  Widget ShowRecommendedPlaces() {
    if (widget.placeInfo.type == 'restaurant') {
      if (restRecommendationIsDone) {
        if (recommendedRestaurants.isEmpty) {
          return Container(
            child: Center(
              child: Text('No Data Available For this Area'),
            ),
          );
        } else {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: recommendedRestaurants,
          );
        }
      } else {
        return Center(child: SpinnerWidget(120));
      }
    } else {
      if (hotelRecommendationIsDone) {
        if (recommendedHotels.isEmpty) {
          return Container(
            child: Center(
              child: Text('No Data Available For this Area'),
            ),
          );
        } else {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: recommendedHotels,
          );
        }
      } else {
        return Center(child: SpinnerWidget(120));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: SearchPage.getImage(
                              widget.placeInfo.photoUrl, widget.placeInfo.type),
                          fit: BoxFit.fill)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_rounded),
                            color: Colors.white,
                            iconSize: 30,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  //ToDO here we should add the love api
                                  if (widget.placeInfo.type == 'restaurant') {
                                    var rest = RestaurantsApi();
                                    var result =
                                        await rest.addRestaurantToWishlist(
                                            widget.placeInfo.place_id,
                                            widget.kind!);
                                    if (result) {
                                      setState(() {
                                        heartColor = Colors.red;
                                      });
                                    } else {
                                      Authenticate.showAlert(this.context,
                                          'something went Wrong try again later');
                                    }
                                  } else {
                                    var hot = HotelsApi();
                                    var result = await hot.addHotelToWishlist(
                                        widget.placeInfo.place_id,
                                        widget.kind!);
                                    if (result) {
                                      setState(() {
                                        heartColor = Colors.red;
                                      });
                                    } else {
                                      Authenticate.showAlert(this.context,
                                          'something went Wrong try again later');
                                    }
                                  }
                                },
                                icon: Icon(Icons.favorite_sharp),
                                iconSize: 40,
                                color: heartColor,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  //ToDo here we should add map
                                  if (mapViewIsPressed){
                                    mapViewIsPressed = false;
                                    mapIconColor = Colors.white;

                                  }
                                  else{
                                    mapViewIsPressed = true;
                                    mapIconColor = Colors.blueAccent;
                                  }
                                  setState(() {
                                  });
                                },
                                icon: Icon(Icons.location_on),
                                iconSize: 40,
                                color: mapIconColor,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  child: Expanded(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              widget.placeInfo.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 15),
                            ),

                            /// TODO: DO Rating Widget
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Rating: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(widget.placeInfo.rating)
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Price: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            // Text('${widget.placeInfo.price}')
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'phone:',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Text(widget.placeInfo.phone)
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Address:',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              width:MediaQuery.of(context).size.width-60,
                                child: Text(widget.placeInfo.Address))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: mapViewIsPressed
                        ? showMap()
                        : [
                            Text(
                              'Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              child: ListView(
                                children: [
                                  Text(widget.placeInfo.description,
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                            )
                          ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Similar ${widget.placeInfo.type}s',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 250,
                        child: ShowRecommendedPlaces(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
