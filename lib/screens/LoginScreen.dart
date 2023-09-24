import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:probots/Networking/login.dart';
import 'package:probots/screens/selectStateScreen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
class Typo extends StatefulWidget {
  const Typo({super.key});

  @override
  State<Typo> createState() => _TypoState();
}

class _TypoState extends State<Typo> {


  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passwordcontrol = TextEditingController();
  bool isloading = false;

  void checkLogin() async{
    try {
      int res = await login(emailcontrol.text, passwordcontrol.text);
      if (res == 200) {
        print("Move to selecting state data");
        Fluttertoast.showToast(msg: "Welcome User");
        var box = Hive.box('storage');
        box.put('user', emailcontrol.text);
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => StateSelectScreen()));
        });
      }
      else if (res == 404) {
        Fluttertoast.showToast(msg: 'No such user with us !');
        emailcontrol.text = '';
        passwordcontrol.text = '';
      }
      else if (res == 401) {
        Fluttertoast.showToast(msg: 'Your subscription as expired');
        emailcontrol.text = '';
        passwordcontrol.text = '';
      }
      else {
        Fluttertoast.showToast(msg: 'Some Error Captured ?');
        emailcontrol.text = '';
        passwordcontrol.text = '';
      }
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: 'Hmmm... we could not connect');
    }
    finally{
      setState(() {
        emailcontrol.text = '';
        passwordcontrol.text = '';
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    emailcontrol.text = "";
    passwordcontrol.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title:  Container(
        alignment: Alignment.center,
        child: const Text("PROBOTS"),),),
        body: Container(

          padding: EdgeInsets.all(width* (kIsWeb?0.06:0.05)),
          alignment: Alignment.center,
        child: isloading?CircularProgressIndicator():Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
                alignment:Alignment.centerLeft,
        child: const Text("Login Email")),
            MaterialTextField(

              keyboardType: TextInputType.emailAddress,
              hint: 'Your Email',
              textInputAction: TextInputAction.next,
              suffixIcon: const Icon(Icons.email),
              controller: emailcontrol,
            ),
            SizedBox(
              height: width *  (kIsWeb?0.005:0.01),
            ),
            Container(
                alignment:Alignment.centerLeft,
                child: const Text("Login Password")
            ),
            MaterialTextField(
              obscureText: true,
              keyboardType: TextInputType.text,
              hint: 'Your Password',
              textInputAction: TextInputAction.next,
              suffixIcon: const Icon(Icons.password),
              controller: passwordcontrol,
            ),

            SizedBox(
              height: width * (kIsWeb?0.01:0.01),
            ),
            Container(
              width: width * (kIsWeb?0.15:0.15),
              height: width * (kIsWeb?0.05:0.15),
              child: ElevatedButton(
                onPressed:() {
                    if(emailcontrol.text!='' && passwordcontrol.text!= '' && emailcontrol.text.length > 6 && passwordcontrol.text.length >= 6){
                      setState(() {
                        isloading = true;
                      });
                      checkLogin();
                    }
                    else{
                      Fluttertoast.showToast(msg: "Please enter valid details");
                    }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlueAccent, // Set the button's background color
                ),
                child:  Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white, fontSize: width * (kIsWeb?0.016:0.06)),
                ),
              ),
            ),
          ],
        ),
    ),
    );
  }
}
