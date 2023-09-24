import 'package:flutter/material.dart';
import 'package:probots/screens/describe_filter.dart';

class TaskTile extends StatefulWidget {
  final String task;
  TaskTile(this.task);
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool? isChecked=false;



  void longPressCallBack(){
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context, builder: (context) => DescribeTaskScreen(width,widget.task));
  }



  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: const Icon(Icons.book),
      onLongPress: longPressCallBack,
      title: Text(widget.task,
      style: TextStyle(
        decoration: isChecked??false?TextDecoration.lineThrough:null,
      ),),
    );
  }
}

