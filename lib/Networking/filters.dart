import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:probots/models/FilterModels.dart';


Future<List<dynamic>> fetchFilters() async {
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  var url = Uri.parse(endpoint+'/get-filters');
  final response = await http.get(url);
  List<dynamic> responseJson = json.decode(response.body.toString())["data"];
  return responseJson;
}

Future<bool> createFilters(filterclassModel filters) async {
  final dio = Dio();
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  var response = await dio.post(endpoint+'/filter-add', data: filters.toJson());
  String responseJson = response.data["status"];
  if(responseJson == "ok")
      return true;
  return false;

}

Future<filterclassModel> getDescribe(String name) async {
  final dio = Dio();
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  var response = await dio.post(endpoint+'/filter-detail', data: {'name':name});
  filterclassModel responseJson = filterclassModel.fromJson(response.data);
  return responseJson;
}

Future<bool> removeFilter(String name) async {
  final dio = Dio();
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  var response = await dio.post(endpoint+'/filter-delete', data: {'name':name});
  if(response.data["status"] == "ok") {
    return true;
  }
  return false;

}
