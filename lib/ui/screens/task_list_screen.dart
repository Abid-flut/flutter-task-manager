

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/state/auth_provider.dart';
import 'package:task_app/state/task_provider.dart';
import 'package:task_app/ui/screens/add_task_screen.dart';
import 'package:task_app/ui/widgets/TaskListBox.dart';


import '../../data/models/task.dart';

class TaskListScreen extends StatefulWidget{

  const TaskListScreen({super.key});

  State<TaskListScreen> createState()=> _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen>{


 void openAddScreen({Task? task}){
   Navigator.push(context,
    MaterialPageRoute(builder:
    (context) =>AddTaskScreen(task: task),
    )
   );
 }

  @override
  void initState() {
    super.initState();
    context.read<TaskProvider>().loadTask();
  }


  @override
  Widget build(BuildContext context) {

    final tasks = context.watch<TaskProvider>();

    void Delete(int id){
      context.read<TaskProvider>().deleteTask(id);
    }
    void Toggle(int id){
      context.read<TaskProvider>().toggleTask(id);
    }
    void restoreTask(Task task,int index){
      context.read<TaskProvider>().restoreTask(task, index);
    }
    void onDismiss(Task task,int id){
      final Task removedTask = task;
      final int removedIndex = tasks.taskList.indexWhere((item)=>item.id==id);
      Delete(id);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: (){
               restoreTask(removedTask, removedIndex);
            })

        ),
      );
    }

    void logout(){
      context.read<AuthProvider>().logout();
    }


    return Scaffold(
      appBar: AppBar(title: Text("Task List"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: logout,
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(tasks.loadingStatus)
              Padding(
                  padding: EdgeInsets.all(8),
                  child:CircularProgressIndicator(),
              ),
            if(tasks.errorOutput!=null)
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(tasks.errorOutput!),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: (){
                  tasks.toggleCompletedFilter();
                },
                  child:
                  Text(tasks.showCompletedTask?"Show All Tasks":"Show Completed Tasks"),
                ),
                SizedBox(width: 10,),
                ElevatedButton(onPressed:tasks.loadingStatus? null:()=> openAddScreen(),
                    child: Text("Add Task") )
              ],
            ),
            Expanded(
              child: tasks.visibleTasks.isEmpty?
                  Center(child: const Text("List is Empty"),):
                ListView.builder
                (
                  itemCount: tasks.visibleTasks.length,
                  itemBuilder: (context,item) {
                    final task = tasks.visibleTasks[item];
                    return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction){
                          onDismiss(task, task.id);
                        },
                        child: TaskListBox(
                            id: task.id,
                            title: task.title,
                            toggle:()=> Toggle(task.id),
                            isCompleted: task.isCompleted,
                            onEdit: ()=> openAddScreen(task: task),
                        ),
                    );
                  }
                  ),

              )
          ],
        ),
    );
  }



}