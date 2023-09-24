import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';


Future<bool> startBot() async {
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  var url = Uri.parse(endpoint+'/bot-start');
  final response = await http.get(url);
  String res= json.decode(response.body.toString())["status"];
  if(res == "ok") return true;
  return false;
}

Future<bool> stopBot() async {
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  var url = Uri.parse(endpoint+'/bot-stop');
  final response = await http.get(url);
  String res= json.decode(response.body.toString())["status"];
  if(res == "ok") return true;
  return false;
}

Future<dynamic> statusBot() async {
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  final dio = Dio();
  var res = await dio.get(endpoint+'/bot-status');
  var resJson = res.data;
  if(resJson["status"] == "running") return [true,resJson["timer"],resJson["state"]];
  if(resJson["status"] == "stopped") return [false,resJson["timer"],resJson["state"]];
  return null;
}
Future<bool> addTimer(String time) async {
  final dio = Dio();
  var box = Hive.box('storage');
  var endpoint = box.get('endpoint');
  var response = await dio.post(endpoint+'/bot-timer', data: {'time':time});
  String responseJson = response.data["status"];
  if(responseJson == "ok")
    return true;
  return false;

}


