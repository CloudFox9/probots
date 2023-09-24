import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:probots/models/task.dart';

class TaskData extends ChangeNotifier{
  List<Task> _tasks=[];
  void addTask(String taskTitle){
    Task newTask= Task(taskTitle: taskTitle);
    _tasks.add(newTask);
    notifyListeners();
  }

  UnmodifiableListView<Task> get tasks{
    return UnmodifiableListView(_tasks);
  }
  void clearAllTasks(){
    _tasks.clear();
    notifyListeners();
  }

  void clearThisTask(Task task){
    _tasks.remove(task);
    notifyListeners();
  }

  int noOfTasks(){
    return _tasks.length;
  }
}