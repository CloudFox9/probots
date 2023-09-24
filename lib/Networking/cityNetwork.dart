import 'dart:async';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:probots/models/FilterModels.dart';

Future<List<String>> stateList() async {
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  final dio = Dio();
  var res = await dio.get(endpoint+'/location-states');
  List<String> response = [];
  for(var r in res.data["data"]){
        response.add(r[1].toString());
  }
  return response;
}


Future<List<MultiList>> cityList() async {
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  String state = box.get('state').toString();
  final dio = Dio();
  var res = await dio.post(endpoint+'/location-cities',data: {"state":state});
  List<MultiList> response = [];
  for(var r in res.data["data"]){
    response.add(MultiList(id: r[0], name: r[1].toString()));
  }
  return response;
}
