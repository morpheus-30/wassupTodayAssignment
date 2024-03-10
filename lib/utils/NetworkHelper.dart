import 'dart:convert';

import 'package:http/http.dart';
import 'package:wassuptoday/constants.dart';

class NetworkHelper {
  NetworkHelper({this.baseurl = 'https://newsapi.org/v2/'});
  String baseurl ;
  
  

  Future<dynamic> getData(String endpoint) async {
    final Response response = await get(Uri.parse(baseurl + endpoint),headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':apikey
    });
    dynamic data = jsonDecode(response.body);
    return data;
  }
}
