import 'dart:async';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
String globalend = 'http://3.81.81.82:5000';
Future<int> login(String user,String pass) async {
  var box = Hive.box('storage');
  final dio = Dio();
  var res = await dio.post('$globalend/check-login',data: {"user":user,"pass":pass});
  var data = res.data;
  print(res.data);
  if(data["status"] == 'expired') {
    return 401;
  }
  if(data["status"] == 'invalid') {
    return 404;
  }
  if(data["status"] == 'ok'){
    print('Endpoint updated');
    box.put('endpoint', data["data"]);
    return 200;
  }
  return 400;
}


Future<bool> allowedlogin(String user) async {
  final dio = Dio();
  var box = Hive.box('storage');
  var res = await dio.post('$globalend/check-allowed',data: {"user":user});
  var data = res.data;
  if(data["status"] == 'ok') {
    box.put('endpoint', data["data"]);
    return true;
  }
    return false;
}