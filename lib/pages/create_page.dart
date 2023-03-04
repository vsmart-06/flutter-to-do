import "package:flutter/material.dart";

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {

  String task = "";
  String date = "";
  String time = "";
  DateTime datetime_date = DateTime.now();
  TimeOfDay time_time = TimeOfDay.now();

  void submit() {
    if (task == "" || date == "" || time == "")
    {
      Navigator.pop(context, null);
    }
    else
    {
      Navigator.pop(context, {"task": task, "date": date, "time": time, "datetime_date": datetime_date, "time_time": time_time});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
        leading: IconButton(onPressed: () {Navigator.pop(context, null);}, icon: Icon(Icons.close)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
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
                    datetime_date = value as DateTime;
                    date = value.toString().split(" ")[0];
                    List date_components = date.split("-");
                    String temp = date_components[0];
                    date_components[0] = date_components[2];
                    date_components[2] = temp;
                    date = date_components.join("/");});
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
                    setState(() {time_time = value as TimeOfDay;
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
                    time = "${time_components[0] < 10 ? 0 : ""}${time_components[0]}:${time_components[1] < 10 ? 0 : ""}${time_components[1]} $meridian";});
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