import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:probots/Networking/cityNetwork.dart';
import 'package:probots/screens/tasks_screen.dart';

class StateSelectScreen extends StatefulWidget {
  StateSelectScreen({super.key});
  @override
  State<StateSelectScreen> createState() => _StateSelectScreenState();
}


class _StateSelectScreenState extends State<StateSelectScreen> {
  static List<String> _stateList = [];
  bool isloading = true;
  String selectedState = 'Select';
  Future<void> fetchState() async{
    var data = await stateList();
    try {
      _stateList = data;
      _stateList.add("Select");
      setState(() {
        isloading = false;
      });
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "Error Encountered");

    }finally{
      setState(() {
      isloading = false;
      });
    }
  }

  @override
  void initState() {
    fetchState();
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
        padding: EdgeInsets.all(width*0.1),
        alignment: Alignment.center,
        child: isloading?CircularProgressIndicator():Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment:Alignment.centerLeft,
                child: const Text("Select Your State")),
            SizedBox(
              height: width * 0.1,
            ),

            Container(
              alignment:Alignment.centerLeft,
              child: DropdownButton<String>(
                value: selectedState,
                items: _stateList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_val) {
                  if(_val != null) {
                    setState(() {
                      selectedState = _val;

                    });
                  }

                },
              ),
            ),
            SizedBox(
              height: width * 0.1,
            ),

            Container(
              height: width * 0.15,
              child: ElevatedButton(
                onPressed:() {
                      setState(() {
                        isloading = true;

                      });
                      if(selectedState != 'Select'){
                      var box = Hive.box('storage');
                      box.put('state',selectedState);
                      Fluttertoast.showToast(msg: "State Saved and will be used.");
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksScreen()));
                      }
                      else{
                        Fluttertoast.showToast(msg: "Select a State Please");
                      }
                      setState(() {
                        isloading = false;
                      });

                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlueAccent, // Set the button's background color
                ),
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.06),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


