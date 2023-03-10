import "package:flutter/material.dart";
import "package:to_do_application/records.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List not_completed = [];
  List completed = [];
  late Records functions;


  void getTasks() {
    completed = functions.getTasks(true);
    not_completed = functions.getTasks(false);
  }

  void updateTask(bool? completed, int index) {
    if (completed != null) {
      if (completed)
      {
        setState(() {
          List task = not_completed[index];
          not_completed.removeAt(index);
          this.completed.add(task);
          functions.toggleCompleted(task[6], true);
        });
      }
      else
      {
        setState(() {
          List task = this.completed[index];
          this.completed.removeAt(index);
          not_completed.add(task);
          functions.toggleCompleted(task[6], false);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    functions = Records();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("To-Do List"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.format_list_numbered_rtl)),
              Tab(icon: Icon(Icons.playlist_add_check),)
            ],
          )
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: not_completed.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey<List>([not_completed[index], index]),
                  onDismissed: (direction) {setState(() {
                    functions.deleteTask(not_completed[index][6]);
                    not_completed = functions.getTasks(false);
                  });},
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            value: false,
                            selected: false,
                            onChanged: (bool? new_value) {updateTask(new_value, index);},
                            title: Text(not_completed[index][0]),
                            subtitle: Text(not_completed[index][1]+" - "+not_completed[index][2]),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        IconButton(onPressed: () async {
                          dynamic result = await Navigator.pushNamed(context, "/edit_task", arguments: {"task": not_completed[index][0], "date": not_completed[index][1], "time": not_completed[index][2], "datetime_date": not_completed[index][3], "time_time": not_completed[index][4], "id": not_completed[index][6]});
                          if (result != null)
                          {
                            setState(() {
                              functions.editTask(not_completed[index][6], result["task"], result["date"], result["time"], result["datetime_date"], result["time_time"]);
                              not_completed = functions.getTasks(false);
                            });
                          }
                          }, icon: Icon(Icons.edit),)
                      ]
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: completed.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey<List>([completed[index], index]),
                  onDismissed: (direction) {setState(() {
                    functions.deleteTask(completed[index][6]);
                    completed = functions.getTasks(true);
                  });},
                  child: Card(
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            value: true,
                            selected: true,
                            onChanged: (bool? new_value) {updateTask(new_value, index);},
                            title: Text(completed[index][0], style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black)),
                            subtitle: Text(completed[index][1]+" - "+completed[index][2], style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[600])),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        IconButton(onPressed: () {setState(() {
                          functions.deleteTask(completed[index][6]);
                          completed = functions.getTasks(true);
                          });}, icon: Icon(Icons.delete))
                      ]
                    ),
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(tooltip: "Create a task", onPressed: () async {
          dynamic result = await Navigator.pushNamed(context, "/create_task");
          if (result != null) {
            setState(() {
              functions.addTask(result["task"], result["date"], result["time"], result["datetime_date"], result["time_time"]);
              not_completed = functions.getTasks(false);
            });
          }
        }, child: Icon(Icons.add))
      ),
    );
  }
}