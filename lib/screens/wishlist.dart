import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/Models/placemodel.dart';
import 'package:travel_guide/Models/citymodel.dart';
import 'package:travel_guide/layouts/drawer.dart';
import 'package:travel_guide/layouts/map.dart';
import 'package:travel_guide/layouts/searchBar.dart';
import 'package:travel_guide/layouts/spinner.dart';
import 'package:travel_guide/screens/place.dart';
import 'package:travel_guide/screens/search.dart';
import 'package:travel_guide/services/hotels.dart';
import 'package:travel_guide/services/resturants.dart';
import 'package:travel_guide/services/weather.dart';

import 'home.dart';

class WishListPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldkeysearch = GlobalKey<ScaffoldState>();

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  bool resturantIsPressed = true;
  bool HotelIspressed = false;
  bool restaurants = false;
  bool hotels = false;
  List<Widget> hotelsData = [];
  List<Widget> restaurantsData = [];

  @override
  void initState() {
    super.initState();
    getWishListPageData();
  }

  void getWishListPageData() async {

    getRestaurants();

    getHotels();
  }

  Future getRestaurants() async {
    var restaurantsApi = RestaurantsApi();
    var Data = await restaurantsApi.getLovedRestaurantsData();

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
            double.parse(item['longitude']));
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
                          image: SearchPage.getImage(
                            item['photo'],
                            'restaurant',
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return PlacePage(rest!,'search');
              // }));
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
        return Container(
          child: Center(
            child: Text(
              'No Data Available For this Area',
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

  Future getHotels() async {
    //TODO : call Hotels api
    var hotelApi = HotelsApi();
    var Data = await hotelApi.getLovedHotelsData();

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
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return PlacePage(hot!,'search');
              // }));
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
      return ListView(
        children: hotelsData,
      );
    } else {
      return Center(child: SpinnerWidget(120));
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
                //TODO : here is avatar and searchBox
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
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon:Icon(Icons.arrow_back_rounded)),
                        SizedBox(
                          width: 60,
                        ),
                        Container(
                          height:50,
                          width: 220
                          ,
                          child: ListTile(
                            leading: Icon(Icons.favorite,color: Colors.red,size:30),
                            title: Align(
                              alignment: Alignment(-3, 0),
                             child:Text(
                              'favourite',
                              style:TextStyle(
                                fontSize: 30,
                                color: Colors.black,

                              ),

                            ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 15,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.all(0.0),
                              decoration: resturantIsPressed
                                  ? BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 5.0,
                                          color: Color(0xFF219ebc))))
                                  : BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                        width: 5,
                                        color: Colors.white70,
                                      ))),
                              child: TextButton(
                                child: Text(
                                  'Restaurants',
                                  style: TextStyle(
                                    color: Color(0xFF219ebc),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    HotelIspressed = false;
                                    resturantIsPressed = true;
                                  });
                                },
                              ),
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(

                            decoration: HotelIspressed
                                ? BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      width: 5.0,
                                      color: Color(0xFF219ebc),
                                    )))
                                : BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      width: 5,
                                      color: Colors.white70,
                                    ))),
                            child: TextButton(
                              child: Text(
                                'Hotels',
                                style: TextStyle(
                                  color: Color(0xFF219ebc),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  HotelIspressed = true;
                                  resturantIsPressed = false;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 550,
                      child: resturantIsPressed
                          ? ShowRestaurants()
                          : ShowHotels(),
                    ),
                  ],
                ))
          ],
        ),
      ),

    );
  }
}
