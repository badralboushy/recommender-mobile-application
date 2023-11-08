import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/Models/placemodel.dart';
import 'package:travel_guide/layouts/drawer.dart';
import 'package:travel_guide/layouts/map.dart';
import 'package:travel_guide/layouts/searchBar.dart';
import 'package:travel_guide/layouts/spinner.dart';
import 'package:travel_guide/screens/place.dart';
import 'package:travel_guide/screens/search.dart';
import 'package:travel_guide/services/hotels.dart';
import 'package:travel_guide/services/resturants.dart';
import 'package:travel_guide/services/location.dart';

import 'home.dart';

class RecommendedPlacesPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldkeysearch = GlobalKey<ScaffoldState>();
  String? kind;
  RecommendedPlacesPage(this.kind);

  @override
  _RecommendedPlacesPageState createState() => _RecommendedPlacesPageState();
}

class _RecommendedPlacesPageState extends State<RecommendedPlacesPage> {
  bool mapViewIsPressed = false;
  bool resturantIsPressed = true;
  bool HotelIspressed = false;
  bool restaurants = false;
  bool hotels = false;
  bool weather = false;
  var weatherData;
  List<Widget> hotelsData = [];
  List<Widget> restaurantsData = [];

  @override
  void initState() {
    super.initState();
    getRecommendedPageData();
  }

  void getRecommendedPageData() async {
    if(widget.kind=='restaurant'){
      getRestaurants();
    }else{
      getHotels();
    }
  }

  Future getRestaurants() async {
    var restaurantsApi = RestaurantsApi();
    var Data = await restaurantsApi.getRecommendedRestaurantData();
    print('get restaurants');
    for (var item in Data['data']) {
      PlaceModel? rest;
      if ((item['longitude'] != 'NONE') && (item['latitude'] != 'NONE')) {
        rest = PlaceModel(
            item['location_id'],
            'restaurant',
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
        places.add(rest);
      }
      restaurantsData.add(
          GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: Row(
                  children:
                  [
                    Container(
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        image: DecorationImage(
                          image: SearchPage.getImage(item['photo'],
                              'restaurant'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10,0,0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 18,
                                width: MediaQuery.of(context).size.width - 175,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Text(item['name']),
                                    ]),
                              ),
                            ],
                          ),
                          Row(
                            //  mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Rating: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),

                              ),
                              Text(item['rating']),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(item['open_now']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]
              ),

            ),

            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PlacePage(rest!,'location');
              }));
            },
          )
      );
    }
    setState(() {
      restaurants = true;
    });
  }

  Widget ShowRestaurants() {
    if (restaurants) {
      if (restaurantsData.isEmpty) {
        return Center(
          child: Container(

            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/no_data.png'),
                  fit: BoxFit.fitHeight,

                )
            ),
          ),
        );
      }
      return ListView(
        children: restaurantsData,
      );
    } else {
      return Center(child: SpinnerWidget(120));
    }
  }

  List<PlaceModel> places = [];

  Future getHotels() async {
    //TODO : call Hotels api
    var hotelApi = HotelsApi();
    var Data = await hotelApi.getRecommendedHotelsData();
    print("helelelelelelele");
    for (var item in Data['data']) {
      PlaceModel? hot;
      if ((item['longitude'] != 'NONE') && (item['latitude'] != 'NONE')) {
        hot = PlaceModel(
            item['location_id'],
            'hotel',
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
        places.add(hot);
      }
      hotelsData.add(
          GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: Row(
                  children:
                  [
                    Container(
                      width: 130,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        image: DecorationImage(
                          image: SearchPage.getImage(
                            item['photo'],
                            'hotel',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10,0,0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 18,
                                width: MediaQuery.of(context).size.width - 175,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Text(item['name']),
                                    ]),
                              ),
                            ],
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'City: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(item['cityName']),
                            ],
                          ),

                          Row(
                            //  mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Rating: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),

                              ),
                              Text(item['rating']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]
              ),

            ),

            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PlacePage(hot!,'location');
              }));
            },
          )
      );
    }
    setState(() {
      hotels = true;
    });
  }

  Widget ShowHotels() {
    if (hotels) {
      if (hotelsData.isEmpty){
        return Center(
          child: Container(
                width:300,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/no_data.png'),
                  fit: BoxFit.fitWidth,


                )
            ),
          ),
        );
      }
      return ListView(
        children: hotelsData,
      );
    } else {
      return Center(child: SpinnerWidget(120));
    }
  }

  Widget ShowPlaces(){
    if(widget.kind=='restaurant'){
      return ShowRestaurants();
    }else{
      return ShowHotels();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldkeysearch,
      drawer: AccountDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color(0xFF023047),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.scaffoldkeysearch.currentState!.openDrawer();
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: CircleAvatar(
                        //  backgroundColor: Colors.red,
                        radius: 25.0,
                        backgroundImage: AssetImage('assets/images/user2.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      // width: 260.0,
                      //height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade500,
                          )),
                      child: Container(
                        height: 35,
                        child: Center(
                          child: SearchBar(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                child: mapViewIsPressed
                    ? MapWidget(Location.latitude,Location.longitude, places,'location')
                    : Container(
                      child: Column(
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon:Icon(Icons.arrow_back_rounded)),
                      SizedBox(
                        width: 0,
                      ),
                      Container(
                        height:70,
                        width: 320
                        ,
                        child: ListTile(
                          leading: Icon(Icons.location_on,color: Colors.lightBlueAccent,size:30),
                          title: Align(

                            alignment: Alignment(-20, 0),
                            child:Text(
                              'Recommended ${widget.kind}s',
                              style:TextStyle(
                                fontSize:25,
                                color: Colors.black,

                              ),

                            ),
                          ),
                        ),
                      )
                        ],
                      ),
                      Divider(
                        thickness:2,
                        color: Color(0xFF023047),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height -240,
                        child: ShowPlaces(),
                      ),
                  ],
                ),
                    ))
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                color: Color(0xFF023047),
                child: TextButton(
                  onPressed: () {
                    //TODO: add functionality to list View Button
                    setState(() {
                      mapViewIsPressed = false;
                    });
                  },
                  child: Text(
                    "list View",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                color: Color(0xFF023047),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      mapViewIsPressed = true;
                    });
                  },
                  child: Text(
                    "Map View",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
