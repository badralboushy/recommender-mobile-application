

class CityModel{
  String? CityName;
  String? Country;
  double? longitude ;
  double? latitude;
  CityModel(String name, String country,double latitude,double longitude){
    this.latitude = latitude ;
    this.longitude = longitude ;
    this.CityName = name ;
    this.Country= country;
  }

  // static  CityModel fromJson ( Map<String,dynamic> json){
  //   CityModel temp = CityModel(CityName: json['CityName'],CityCountry: json['CityCountry'],latitude: json['latitude'],
  //   longitude: json['longitude']);
  //   return temp;
  // }

}