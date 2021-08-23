import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_first_app/models/activity_model.dart';
import '../models/city_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class CityProvider with ChangeNotifier {
  final String host = 'http://10.0.2.2';
  List<City> _cities = [];
  bool isLoading = false;

  UnmodifiableListView<City> get cities => UnmodifiableListView(_cities);

  City getCityByName(String cityName) =>
      cities.firstWhere((city) => city.name == cityName);

  UnmodifiableListView<City> getFilteredCities(String filter) =>
      UnmodifiableListView(
        _cities
            .where(
              (city) => city.name.toLowerCase().startsWith(
                    filter.toLowerCase(),
                  ),
            )
            .toList(),
      );

  Future<void> fetchData() async {
    var url = Uri.parse('$host/api/cities');
    try {
      isLoading = true;
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        _cities = (json.decode(response.body) as List)
            .map((cityJson) => City.fromJson(cityJson))
            .toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> addActivityToCity(Activity newActivity) async {
    String cityId = getCityByName(newActivity.city).id;
    var url = Uri.parse('$host/api/city/$cityId/activity');
    try {
      http.Response response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: json.encode(
          newActivity.toJson(),
        ),
      );
      if (response.statusCode == 200) {
        int index = cities.indexWhere((city) => city.id == cityId);
        _cities[index] = City.fromJson(
          json.decode(response.body),
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> verifyIfActivityNameIsUnique(
      String cityName, String activityName) async {
    City city = getCityByName(cityName);
    var url =
        Uri.parse('$host/api/city/${city.id}/activities/verify/$activityName');
    try {
      http.Response response = await http.get(url);
      if (response.body != null) {
        return json.decode(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(File pickedImage) async {
    try {
      var url = Uri.parse('$host/api/activity/image');
      var request = http.MultipartRequest("POST", url);
      request.files.add(
        http.MultipartFile.fromBytes(
          'activity',
          pickedImage.readAsBytesSync(),
          filename: basename(pickedImage.path),
          contentType: MediaType("multipart", "form-data"),
        ),
      );
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        return json.decode(String.fromCharCodes(responseData));
      } else {
        throw 'error';
      }

      // return ;
    } catch (e) {
      rethrow;
    }
  }
}
