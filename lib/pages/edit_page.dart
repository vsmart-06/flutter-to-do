import "package:flutter/material.dart";

class EditTask extends StatefulWidget {
  const EditTask({super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  String task = "";
  String date = "";
  String time = "";
  int id = 0;
  late DateTime datetime_date;
  late TimeOfDay time_time;
  Map data = {};

  void submit() {
    if (task == "" || date == "" || time == "")
    {
      Navigator.pop(context, null);
    }
    else
    {
      Navigator.pop(context, {"task": task, "date": date, "time": time, "datetime_date": datetime_date, "time_time": time_time, "id": id});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    try
    {
      if (data.isEmpty)
      {
        data = ModalRoute.of(context)!.settings.arguments as Map;
        task = data["task"];
        date = data["date"];
        time = data["time"];
        id = data["id"];
        datetime_date = data["datetime_date"];
        time_time = data["time_time"];
      }
    }
    catch(e)
    {
      data = data;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
        leading: IconButton(onPressed: () {Navigator.pop(context, null);}, icon: Icon(Icons.close)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                initialValue: task,
                onChanged: (value) {task = value;},
                decoration: InputDecoration(
                  labelText: "Task",
                  hintText: "Ex: Complete mathematics homework"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  showDatePicker(
                    context: context, 
                    initialDate: datetime_date, 
                    firstDate: DateTime.now(), 
                    lastDate: DateTime.now().add(Duration(days: 365))
                  ).then((value) {
                    setState(() {
                    try {
                      datetime_date = value as DateTime;
                      date = value.toString().split(" ")[0];
                      List date_components = date.split("-");
                      String temp = date_components[0];
                      date_components[0] = date_components[2];
                      date_components[2] = temp;
                      date = date_components.join("/");
                    }
                    catch(e) {}
                    });
                  },);
                }, 
                child: Row(
                  children: [
                    Expanded(child: Text(date == "" ? "Pick a date" : date)),
                    Icon(Icons.calendar_today),
                  ],
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  showTimePicker(
                    context: context, 
                    initialTime: time_time
                  ).then((value) {
                    setState(() {
                    try {
                      time_time = value as TimeOfDay;
                      time = value.toString();
                      time = time.split("(")[1].split(")")[0];
                      List<int> time_components = [int.parse(time.split(":")[0]), int.parse(time.split(":")[1])];
                      String meridian = time_components[0] >= 12 ? "PM" : "AM";
                      if (time_components[0] >= 12)
                      {
                        time_components[0] -= 12;
                      }
                      if (time_components[0] == 0)
                      {
                        time_components[0] = 12;
                      }
                      time = "${time_components[0] < 10 ? 0 : ""}${time_components[0]}:${time_components[1] < 10 ? 0 : ""}${time_components[1]} $meridian";
                    }
                    catch(e) {}
                    });
                  },);
                }, 
                child: Row(
                  children: [
                    Expanded(child: Text(time == "" ? "Select a time": time)),
                    Icon(Icons.schedule),
                  ],
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {submit();},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )
                        )
                      ),
                      child: Text("Save")
                    ),
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }
}