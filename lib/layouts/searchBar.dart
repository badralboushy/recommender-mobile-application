import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:travel_guide/Models/citymodel.dart';
import 'package:travel_guide/screens/search.dart';
import 'package:travel_guide/services/AutoCompleteApi.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  //   // TODO: Three steps
  //   //1: Load Suggestion from the api ... check
  //   //2: display the suggestion
  //   //3: click on the suggestion

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<CityModel>(
      hideSuggestionsOnKeyboardHide: false,
      debounceDuration: Duration(milliseconds: 250),
      textFieldConfiguration: TextFieldConfiguration(
        style:TextStyle(
          fontSize: 15 ,
        ),

          decoration: InputDecoration(
        prefixIcon: Icon(Icons.search , size:30,),
        //border: OutlineInputBorder(),
        hintText: 'Search for city..',
      )),
      suggestionsCallback: AutoCompleteApi.getSuggestedCities,
      itemBuilder: (context, CityModel? suggestion) {
        final city = suggestion!;
        return ListTile(
          leading: Icon(Icons.place_sharp ,),
          title: Text('${city.CityName},${city.Country}'),
        );
      },
      onSuggestionSelected: (CityModel? suggestion) {
        final city = suggestion!;
       Navigator.push(context,MaterialPageRoute(
         builder: (context){
           return SearchPage(city);
         }
       ));
      },
      noItemsFoundBuilder: (context) => Container(
        height: 100,
        child: Center(
            child: Text(
          'No Cities Found.',
          style: TextStyle(fontSize: 24),
        )),
      ),
    );
  }
}
