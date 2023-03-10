import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

class Records {

  final box = Hive.box("user_tasks");

  void addTask(String task, String date, String time, DateTime datetime_date, TimeOfDay time_time) {
    String time_time_string = time_time.toString();
    box.add({"task": task, "date": date, "time": time, "datetime_date": datetime_date, "time_time": time_time_string, "completed": false});
  }

  void editTask(int id, String task, String date, String time, DateTime datetime_date, TimeOfDay time_time) {
    String time_time_string = time_time.toString();
    box.put(id, {"task": task, "date": date, "time": time, "datetime_date": datetime_date, "time_time": time_time_string, "completed": false});
  }

  void deleteTask(int id) {
    box.delete(id);
  }

  void toggleCompleted(int id, bool completed) {
    Map data = box.get(id);
    data["completed"] = completed;
    box.put(id, data);
  }

  List<List> getTasks(bool completed) {
    List<List> values = [];
    for (int i = 0; i < box.values.length; i++)
    {
      List data = [];
      Map x = box.values.toList()[i];
      for (int j = 0; j < x.values.length; j++)
      {
        var y = x.values.toList()[j];
        if (j == 4)
        {
          String time = y.split("(")[1].split(")")[0];
          List<int> time_components = [int.parse(time.split(":")[0]), int.parse(time.split(":")[1])];
          y = TimeOfDay(hour: time_components[0], minute: time_components[1]);
        }
        data.add(y);
      }
      data.add(box.keys.toList()[i]);
      if (data[5] == completed) {values.add(data);}
    }
    return values;
  }
}