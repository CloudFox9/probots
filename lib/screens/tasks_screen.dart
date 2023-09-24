import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:probots/screens/add_task_screen.dart';
import 'package:probots/screens/start_botscreen.dart';
import 'package:probots/widgets/task_tile.dart';
import 'package:probots/Networking/filters.dart';
class TasksScreen extends StatefulWidget {
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {


  Future<void> fetch() async{
    print("Fetch called");
    List<dynamic> data = await fetchFilters();
      setState(() {
        taskList = [];

      if(data.length != 0 ){
        print('state changed');
        for(var d in data) {
          print("object");
          taskList.add(d.toString());
        }
      }
      });

  }


  List<String> taskList = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context, builder: (context) => AddTaskScreen(width)).then((value)
            {
              setState(() {
                fetch();
              });
            });
          }),
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetch,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: height * 0.03,
                  left: width * 0.05,
                  right: width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap:fetch,
                          onLongPress: fetch,
                          child: CircleAvatar(
                            radius: width * 0.08,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.local_shipping,
                              size: width * 0.09,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                        Material(
                          elevation: 15.0,
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * 0.03)),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(width * 0.03))),
                            child: IconButton(
                              icon: Icon(
                                Icons.start,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context, builder: (context) => StatusScreen(width)).then((value) {
                                      setState(() {
                                        fetch();
                                      });
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width * 0.03,
                    ),
                    Text(
                      'Probots',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' Active Filter(s)',
                      style:
                          TextStyle(color: Colors.white, fontSize: width * 0.05),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: height * 0.03),
                  padding: EdgeInsets.only(
                    left: width * 0.05,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(width * 0.07),
                      topRight: Radius.circular(width * 0.07),
                    ),
                  ),
                  child: taskList.length == 0
                      ? Center(child: Text('No Task added!'))
                      : ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TaskTile(taskList[index]);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  Future<dynamic> showDeleteAllDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Add some tasks first.'),
        actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
      ),
    );
  }
}
