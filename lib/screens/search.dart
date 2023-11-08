import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_guide/Models/placemodel.dart';
import 'package:travel_guide/Models/citymodel.dart';
import 'package:travel_guide/layouts/drawer.dart';
import 'package:travel_guide/layouts/map.dart';
import 'package:travel_guide/layouts/searchBar.dart';
import 'package:travel_guide/layouts/spinner.dart';
import 'package:travel_guide/screens/place.dart';
import 'package:travel_guide/services/hotels.dart';
import 'package:travel_guide/services/resturants.dart';
import 'package:travel_guide/services/weather.dart';

class SearchPage extends StatefulWidget {
  CityModel city = CityModel('asdf', 'asd', 0.0, 0.0);
  GlobalKey<ScaffoldState> scaffoldkeysearch = GlobalKey<ScaffoldState>();

  SearchPage(this.city);

  static ImageProvider getImage(String imageUrl, String type) {
    if (imageUrl == "NONE") {
      if (type == 'hotel')
        return AssetImage('assets/images/hotel.jpg');
      else {
        return AssetImage('assets/images/food.jpg');
      }
    }
    return NetworkImage(imageUrl);
  }

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    getSearchPageData();
  }

  void getSearchPageData() async {
    getWeather();

    getRestaurants();

    getHotels();
  }

  Future getRestaurants() async {
    var restaurantsApi = RestaurantsApi();
    var Data = await restaurantsApi.getRestaurantsData(
        widget.city.latitude, widget.city.longitude,'search');

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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PlacePage(rest!,'search');
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

  Future getWeather() async {
    var weatherApi = WeatherApi();
    weatherData = await weatherApi.getWeatherData(
        widget.city.latitude, widget.city.longitude);

    setState(() {
      weather = true;
    });
  }

  Widget ShowWeather() {
    if (weather) {
      return ListTile(
        leading: Container(
          width: 50,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: SearchPage.getImage(
                  'https:${weatherData['data']['current_weather_icon']}',
                  'hotel'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Column(
          children: [
            Row(
              children: [
                Text(
                  'Region: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  height: 18,
                  width: MediaQuery.of(context).size.width - 200,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    Text(
                        '${weatherData['data']['name']} ,${weatherData['data']['region']}'),
                  ]),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Country: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(weatherData['data']['country']),
              ],
            ),
            Row(
              children: [
                Text(
                  'Weather: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(weatherData['data']['current_weather_text']),
              ],
            ),
            Row(
              children: [
                Text(
                  'Temperature:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('${weatherData['data']['current_temp_c']} C'),
              ],
            ),
          ],
        ),
      );
    } else {
      return Center(child: SpinnerWidget(40));
    }
  }

  List<PlaceModel> places = [];

  Future getHotels() async {
    //TODO : call Hotels api
    var hotelApi = HotelsApi();
    var Data = await hotelApi.getHotelsData(
        widget.city.latitude, widget.city.longitude,'search');

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
                return PlacePage(hot!,'search');
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
                child: mapViewIsPressed
                    ? MapWidget(
                        widget.city.latitude, widget.city.longitude, places,'search')
                    : Column(
                        children: [
                          Container(
                            //TODO : here is Weather and Time Card
                            width: double.infinity,
                            //height: 120,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFF8ECAE6),
                              // border: Border.all(
                              //   color: Color(0xFF1E303C),
                              // ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: ShowWeather(),
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
                            height: 460.0,
                            child: resturantIsPressed
                                ? ShowRestaurants()
                                : ShowHotels(),
                          ),
                        ],
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
                    //TODO:add functionality to Map View Button
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
