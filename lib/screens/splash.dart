import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:probots/screens/LoginScreen.dart';
import 'package:probots/screens/selectStateScreen.dart';
import 'package:probots/screens/tasks_screen.dart';

import '../Networking/login.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  late Future<bool> loginCheckFuture;
  bool stateSave() {
    var box = Hive.box('storage');
    if (box.get('state') != null) return true;
    return false;
  }

  Future<bool> checkAllowed() async {
    try {
      var box = Hive.box('storage');
      if (box.get('user') != null) {
        bool ans = await allowedlogin(box.get('user'));
        return ans;
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "hmm.. failed to conn");
      return false;
    }
  }

  bool hiveStatus() {
    var box = Hive.box('storage');
    if (box.get('endpoint') != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    loginCheckFuture = checkAllowed();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    return FutureBuilder(
        future: loginCheckFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data == true) && hiveStatus()) {
              if(stateSave()){
                child = TasksScreen();
              }
              else{
                child = StateSelectScreen();
              }
            } else {
              child = const Typo();
            }
          } else {
            // future hasnt completed yet
            child = CircularProgressIndicator();
          }

          return Scaffold(
            body: child,
          );
        });
  }
}
