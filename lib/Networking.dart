import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "Ok3iMT6dMopJu3NZr6veuPJFNs8QZJPSl6piUpWGNC0";

const apiUrl = 'https://api.unsplash.com/photos?client_id=$apiKey';

class Images{

  Future getLatestImages(int pageNumber) async {
    String url = '$apiUrl&order_by=latest&orientation=portrait&&per_page=30&page=$pageNumber';
    http.Response response = await http.get(url);

    List responseData = [];

    if(response.statusCode == 200){
      String body = response.body;
      var decodedData = jsonDecode(body);

      for (var i in decodedData){
        if (i['height'] > i['width']){
          List listData = [];
          listData.add(i['id']);
          listData.add(i['urls']['regular']);
          listData.add(i['urls']['thumb']);
          listData.add(i['links']['download']);
          responseData.add(listData);
        }
      }
    }else{
      print(response.statusCode);
    }

//    print(responseData);
    return responseData;
  }

  Future getTrendingImages(int pageNumber) async {
    String url = '$apiUrl&order_by=popular&orientation=portrait&&per_page=30&page=$pageNumber';
    http.Response response = await http.get(url);

    List responseData = [];

    if(response.statusCode == 200){
      String body = response.body;
      var decodedData = jsonDecode(body);

      for (var i in decodedData){
        if (i['height'] > i['width']){
          List listData = [];
          listData.add(i['id']);
          listData.add(i['urls']['regular']);
          listData.add(i['urls']['thumb']);
          listData.add(i['links']['download']);
          responseData.add(listData);
        }
      }
    }else{
      print(response.statusCode);
    }

    return responseData;
  }

  Future getSearchImages(int pageNumber, String query) async {
    String url = 'https://api.unsplash.com/search/photos?client_id=$apiKey&query=$query&orientation=portrait&page=$pageNumber';
    http.Response response = await http.get(url);

    List responseData = [];

    if(response.statusCode == 200){
      String body = response.body;
      var decodedData = jsonDecode(body);

      for (var i in decodedData['results']){
        if (i['height'] > i['width']){
          List listData = [];
          listData.add(i['id']);
          listData.add(i['urls']['regular']);
          listData.add(i['urls']['thumb']);
          listData.add(i['urls']['thumb']);
          listData.add(i['links']['download']);
          responseData.add(listData);
        }
      }
    }else{
      print(response.statusCode);
    }

    return responseData;
  }
}

