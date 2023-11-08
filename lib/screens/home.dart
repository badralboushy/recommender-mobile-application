import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_guide/Models/citymodel.dart';
import 'package:travel_guide/Models/placemodel.dart';
import 'package:travel_guide/layouts/drawer.dart';
import 'package:travel_guide/layouts/map.dart';
import 'package:travel_guide/layouts/searchBar.dart';
import 'package:travel_guide/layouts/spinner.dart';
import 'package:travel_guide/screens/place.dart';
import 'package:travel_guide/screens/recommended_places.dart';
import 'package:travel_guide/screens/search.dart';
import 'package:travel_guide/services/hotels.dart';
import 'package:travel_guide/services/resturants.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:travel_guide/services/location.dart';
import 'package:travel_guide/services/weather.dart';
import 'package:travel_guide/services/AutoCompleteApi.dart';

class HomePage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool weather = false;
  bool restaurants = false;
  bool hotels = false;
  var weatherData ;
  List<Widget> hotelsData =[];
  List<Widget> restaurantsData= [] ;
  bool mapViewIsPressed = false ;
  List<PlaceModel> places = <PlaceModel>[] ;

  @override
  void initState() {
    super.initState();
    getHomePageData();
  }
  void getHomePageData()async{
    await Location.getCurrentLocation();
     getWeather(Location.latitude!,Location.longitude!);
     getHotels(Location.latitude!,Location.longitude!);
     getRestaurants(Location.latitude!,Location.longitude!);
  }
  Future getHotels(double latitude, double longitude)async{
    var hotelApi = HotelsApi();
    var Data = await hotelApi.getHotelsData(latitude,longitude,'location');

    for ( var item in Data['data']){
      PlaceModel? hot ;
      if ((item['longitude'] != 'NONE') && (item['latitude'] != 'NONE')){
        hot= PlaceModel(
            item['location_id'],
            'hotel',
                item['name'],
                item['description'],
                item['rating'],
                item['address'],
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
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>PlacePage(hot!,'location')));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 160.0,
                  height: 170,
                  margin: EdgeInsets.symmetric(vertical:10,horizontal: 5),
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      image:DecorationImage(
                        image:SearchPage.getImage(item['photo'],'hotel'),
                        fit: BoxFit.cover,
                      ),
                      color:Colors.white,
                      border:Border.all(
                        color: Color(0xFF023047),
                      ) ,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),

                ),
                Column(
                    children: [
                      Container(
                        width:160 ,
                        child: Center(
                          child: Expanded(
                            child: Text(
                              item['name']=='NONE'?'No name is Available':item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
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
                            item['rating']=='NONE' ? 'no rating' : item['rating'],
                          ),
                        ],
                      ),
                    ]
                )
              ],
            ),
          )
      );
    }

    setState(() {
      hotels = true ;

    });
  }

  Widget ShowHotels(){
    if(hotels){
      if (hotelsData.isEmpty){
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
        scrollDirection: Axis.horizontal,
        children: hotelsData,
      );

    }else{
      return Center(
          child:SpinnerWidget(120)
      ) ;
    }

  }

  Future getRestaurants(double latitude, double longitude)async{
    var restaurantsApi = RestaurantsApi();
    var Data = await restaurantsApi.getRestaurantsData(latitude,longitude,'location');

    for ( var item in Data['data']){
      PlaceModel? rest ;
      if ((item['longitude'] != 'NONE') && (item['latitude'] != 'NONE')){
        rest = PlaceModel(
            item['location_id'],
            'restaurant',
                item['name'],
                item['description'],
                item['rating'],
                item['address'],
                item['phone'],
                item['photo'],
               double.parse(item['latitude']),
               double.parse( item['longitude']),
               // item['price']
        );
        places.add(rest);
      }

      restaurantsData.add(
          GestureDetector(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>PlacePage(rest!,'location')));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 160.0,
                  height: 170,
                  margin: EdgeInsets.symmetric(vertical:10,horizontal: 5),
                  // padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                     image:DecorationImage(
                       image:SearchPage.getImage(item['photo'],'restaurant'),
                       fit: BoxFit.cover,
                     ),
                      color:Colors.white,
                     border:Border.all(
                       color: Color(0xFF023047),
                      ) ,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),

                  ),
            Column(
              children: [
                Container(
                  width:160 ,
                  child: Center(
                    child: Text(
                        item['name']=='NONE'?'No name is Available':item['name'],
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
                        item['rating']=='NONE' ? 'no rating' : item['rating'],
                    ),
                  ],
                ),
              ]
            )
              ],
            ),
          )
      );
    }
    setState(() {
      restaurants = true ;

    });
  }

  Widget ShowRestaurants(){
    if(restaurants){
      if (restaurantsData.isEmpty){
        return Container(
          child: Center(
            child: Text(
                'No Data Available For this Area'
            ),
          ),
        );
      }
      return ListView(
        scrollDirection: Axis.horizontal,
        children: restaurantsData,
      );

    }else{
      return Center(
          child:SpinnerWidget(120)
      ) ;
    }

  }


  Future getWeather(double latitude, double longitude)async{
    var weatherApi = WeatherApi();
    weatherData = await weatherApi.getWeatherData(latitude,longitude);
    setState(() {
      weather = true ;
    });
  }

  Widget ShowWeather(){
      if(weather){
        return ListTile(

          leading:Container(
             width:80,
             height:150,

            decoration: BoxDecoration(
              image: DecorationImage(
                image: SearchPage.getImage('https:${weatherData['data']['current_weather_icon']}','hotel'),
                fit:BoxFit.fitWidth,
              ),
            ),
          )
           ,
          title: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Region: ',
                    style:TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    height: 18,
                    width: MediaQuery.of(context).size.width - 230,
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
                    style:TextStyle(
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
                    style:TextStyle(
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
                    style:TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('${weatherData['data']['current_temp_c']} C'),
                ],
              ),
            ],
          ),

        );
      }else{
        return Center(
          child:SpinnerWidget(50)
        ) ;
      }

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key:widget.scaffoldkey,
        drawer: AccountDrawer(),
        backgroundColor:Colors.white,
        //Colors.lightBlue[50],
        body: SingleChildScrollView(
          child: SafeArea(

            child: Column(
              children: [
                Container(
                  color: Color(0xFF023047),
                  child: Row(
                    //TODO : here is avatar and searchBox
                    children: [
                      GestureDetector(
                        onTap:(){
                          widget.scaffoldkey.currentState!.openDrawer();
                            },
                        child: Container(
                          margin:EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: CircleAvatar(

                            //  backgroundColor: Colors.red,
                            radius:25.0,
                            backgroundImage: AssetImage('assets/images/user2.png'),
                          ),
                        ),
                        ),
                          Expanded(
                            child: Container(
                             margin:EdgeInsets.fromLTRB(15, 15,15, 15),
                             // width: 260.0,
                              //height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                            border: Border.all(
                              color : Colors.grey.shade500,
                            )
                        ),
                             child: Container(
                               height: 35,
                                 child: Center(
                                     child: SearchBar(),),),
                         ),
                          ),

                      ],
                    ),
                ),
                Container(
                  child:
                      mapViewIsPressed?
                          MapWidget(Location.latitude,Location.longitude , places,'location'):




                  Column(
                    children: [
                      Container(
                        //TODO : here is Weather and Time Card
                        width: double.infinity,
                        //height: 120,
                        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFF8ECAE6),
                          // border: Border.all(
                          //   color: Color(0xFF1E303C),
                          // ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child:ShowWeather(),
                      ),
                      Divider(
                        height: 30,
                        thickness:1,
                      ),

                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                                child: Text('Restaurants :',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,

                                ),
                                ),
                              ),
                              Container(
                                  child:GestureDetector(
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Recommended',
                                          style: TextStyle(fontSize: 20),),
                                        Icon(Icons.arrow_forward_ios_sharp)
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>RecommendedPlacesPage('restaurant')));
                                    },
                                  )
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Container(
                            height: 250,
                            child: ShowRestaurants(),

                          ),
                          SizedBox(
                            height: 5,
                          ),


                        ],
                        //TODO : here is Restaurants horizontal List
                      ),
                      Divider(
                        height: 30,
                        thickness:1,
                        //color: Color(0xFF023047),
                      ),
                      Column(
                        //TODO: here is Hotels horizontal List
                        children: [
                          Row(

                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:0,horizontal: 15),
                                child: Text('Hotels :',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,

                                  ),
                                ),
                              ),
                              Container(
                                  child:GestureDetector(
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Recommended',
                                          style: TextStyle(fontSize: 20),),
                                        Icon(Icons.arrow_forward_ios_sharp)
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>RecommendedPlacesPage('hotel')));

                                    },
                                  )
                              ),
                            ],
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          ),
                          Container(
                            height: 200,
                            child:ShowHotels(),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                        ],
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),

        persistentFooterButtons:
        [
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
