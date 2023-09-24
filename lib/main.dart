import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:probots/screens/splash.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


Future<void> hivebox() async {
  String path;
  if (kIsWeb) {
   path = "/assets/db";
  }
  else {
    final dbDir = await path_provider.getApplicationDocumentsDirectory();
   path = dbDir.path;
  }
  // final dbDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(path);
  await Hive.openBox('storage');
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await hivebox();
  var box = Hive.box('storage');
  box.put('endpoint',"http://192.168.1.6:5000");
  // box.put('state',"Florida");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context){
    return MaterialApp(

      title: 'Probots',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black45 ),
        useMaterial3: true,
      ),
      home: const CheckAuth()
    );
  }
}


