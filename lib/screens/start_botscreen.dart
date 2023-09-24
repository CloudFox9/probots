import 'package:flutter/material.dart';
import 'package:probots/Networking/botFunctions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StatusScreen extends StatefulWidget {
  final double width;
  StatusScreen(this.width);
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  TextEditingController timeinput = TextEditingController();
  bool isloading = true;
  late bool status;
  String timer = '-';
  String statusval = '-';
  late final TimeOfDay activeTimer;
  late Future<TimeOfDay?> selectedTime;
  String time = "-";

  void showDialogTimePicker(BuildContext context) {
    selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // primary: MyColors.primary,
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            //.dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        time = "${value.hour} : ${value.minute}";
        timeinput.text = time;
        activeTimer = value;
      });
    }, onError: (error) {
      print(error);
    });
  }

  void fetch() async {
    try {
      var res = await statusBot();
      if (res != null) {
        status = res[0] as bool;
        if (status)
          statusval = "Running";
        else
          statusval = "Stopped";
        timer = res[1];
        if(res[2] == "error") Fluttertoast.showToast(msg: "Bot as faced 10 errors report !",timeInSecForIosWeb: 10,);
        setState(() {
          isloading = false;
        });
      } else
        Fluttertoast.showToast(msg: "Could not load bot resource Err : 12");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Could not load bot resource");
    }
  }

  @override
  void initState() {
    timeinput.text = "";
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.width * 0.1,
          vertical: widget.width * 0.1,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.width * 0.07),
            topRight: Radius.circular(widget.width * 0.07),
          ),
        ),
        child: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      " Bot Status : ${statusval}",
                      style: TextStyle(
                          color: Colors.black, fontSize: widget.width * 0.05),
                    ),
                    Text(
                      " Bot Timer  : ${timer}",
                      style: TextStyle(
                          color: Colors.black, fontSize: widget.width * 0.05),
                    ),
                    SizedBox(
                      height: widget.width * 0.1,
                    ),
                    TextField(
                      controller:
                          timeinput, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.timer), //icon of text field
                          labelText: "Enter Time" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        showDialogTimePicker(context);
                      },
                    ),
                    SizedBox(
                      height: widget.width * 0.1,
                    ),
                    Container(
                      height: widget.width * 0.1,
                      child: ElevatedButton(
                        onPressed: () {
                          _botTimer(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: status
                              ? Colors.red
                              : Colors
                                  .green, // Set the button's background color
                        ),
                        child: Text(
                          (timeinput.text != '')
                              ? "Add/Change Timer"
                              : status
                                  ? 'Stop Bot'
                                  : 'Start Bot',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.width * 0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
  void _botTimer(BuildContext context) async {
    if (timeinput.text != '') {
      try {
        print("Timer Mode !");
        bool res = await addTimer(timeinput.text);
        if (res)
          Fluttertoast.showToast(msg: "Timer Updated !");
        else
          Fluttertoast.showToast(msg: "Timer Could not be added !");
      } catch (e) {
        print(e);
        Fluttertoast.showToast(msg: "Error Encountered !");
      }
    } else {
      print("start/stop bot");
      if (status) {
        print("stop the bot !");
        try {
          bool res = await stopBot();
          if (res)
            Fluttertoast.showToast(msg: "Stop Action Complete!");
          else
            Fluttertoast.showToast(msg: " Stop Action Failed");
        } catch (e) {
          print(e);
          Fluttertoast.showToast(msg: "Exception encountered");
        }
      } else {
        print("start the bot !");
        try {
          bool res = await startBot();
          if (res)
            Fluttertoast.showToast(msg: "Start Action Complete!");
          else
            Fluttertoast.showToast(msg: "Start Action Failed");
        } catch (e) {
          print(e);
          Fluttertoast.showToast(msg: "Exception encountered");
        }
      }
    }
    Navigator.pop(context);
  }
}
