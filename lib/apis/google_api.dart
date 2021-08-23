import 'package:my_first_app/models/activity_model.dart';
import 'package:my_first_app/models/place_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_KEY_API = 'AIzaSyCfDpdZss3of-UXSjtaDWkGFgRWqH7ePFA';
Uri _queryAutocompleteBuilder(String query) {
  return Uri.parse(
      'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=$GOOGLE_KEY_API&input=$query');
}

Uri _queryPlaceDetailsBuilder(String placeId) {
  return Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,geometry&key=$GOOGLE_KEY_API');
}

// ignore: missing_return
Future<List<Place>> getAutocompleteSuggestions(String query) async {
  try {
    var response = await http.get(_queryAutocompleteBuilder(query));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return (body['predictions'] as List)
          .map(
            (suggestion) => Place(
              description: suggestion['description'],
              placeId: suggestion['place_id'],
            ),
          )
          .toList();
    }
  } catch (e) {
    rethrow;
  }
}

Future<LocationActivity> getPlaceDetailsApi(String placeId) async {
  try {
    var response = await http.get(_queryPlaceDetailsBuilder(placeId));
    if (response.statusCode == 200) {
      var body = json.decode(response.body)['result'];
      return LocationActivity(
        address: body['formatted_address'],
        longitude: body['geometry']['location']['lng'],
        latitude: body['geometry']['location']['lat'],
      );
    } else {
      return null;
    }
  } catch (e) {
    rethrow;
  }
}
